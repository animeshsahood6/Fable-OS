"""JARVIS Voice Runtime - headless self-test (ADR-022 / TESTING_ENGINE).

Validates every voice component that does NOT require a live mic/speaker or the
operator's voice: TTS synthesis, STT transcription (round-trip: TTS -> WAV ->
STT must recover the words), the openWakeWord 'hey_jarvis' model, and that
Python can see audio input/output devices. The live spoken loop (wake word from
a real mic + barge-in) is the operator's physical validation - not covered here.

Run via tests\voice.ps1 (uses the voice venv). Exit code = number of failures.
"""
import os
import sys
import tempfile

sys.stdout.reconfigure(encoding="utf-8", errors="replace")
sys.path.insert(0, r"D:\Fable OS\config\kernel")
fails = 0
MODELS = r"D:/Fable OS/config/voice/models"
PHRASE = "The Jarvis runtime is now online."


def check(name, ok):
    global fails
    print(f"  {'PASS' if ok else 'FAIL'}  {name}")
    if not ok:
        fails += 1


# 0) speech sanitization seam (ADR-034) - Kokoro must never see formatting
import jarvis_speech as SP
CASES = [
    ("**important things**", "important things"),
    ("*laughs*", "Haha."),
    ("*sighs* fine.", "fine."),
    ("# Heading\n- bullet one\n1. bullet two", "Heading bullet one bullet two"),
    ("See [the docs](http://x) and `run()` now.", "See the docs and run() now."),
    ("| a | b |\n|---|---|\n| 1 | 2 |", "a, b 1, 2"),
    ("__under__ and _ital_ and *emph*", "under and ital and emph"),
    ("> quoted wisdom", "quoted wisdom"),
]
bad = [(i, SP.sanitize(i), want) for i, want in CASES if SP.sanitize(i) != want]
check(f"SPEECH: sanitize handles md/roleplay ({len(CASES)-len(bad)}/{len(CASES)})", not bad)
for i, got, want in bad:
    print(f"        {i!r} -> {got!r} (wanted {want!r})")
sc = SP.Speechify()
sents = sc.feed("Hello **wor"); sents += sc.feed("ld**. <th")
sents += sc.feed("ink>secret stuff</think> Done."); tail = sc.flush()
check(f"SPEECH: stream keeps sentences, drops split think-tags ({sents}+{tail!r})",
      sents == ["Hello world.", "Done."] and tail == "" and "secret" not in str(sents))
sc = SP.Speechify()
out = sc.feed("Look:\n```py\nx=1\n```\nAll set."); out += [sc.flush()]
check(f"SPEECH: fenced code becomes 'Code omitted.' ({out})",
      out[:2] == ["Look:", "Code omitted."] and "x=1" not in str(out))

# 0b) recorder-config contract (ADR-035): wake word ALWAYS armed; the
# conversation window is the wake-free VAD period after each listen start
import jarvis_voice as JV
rc = JV.build_recorder_config(JV.CFG)
check("LOOP: wake word always armed + conversation window set",
      rc.get("wakeword_backend") == "oww" and rc.get("wake_words") == "hey_jarvis"
      and rc.get("wake_word_activation_delay")
      == float(JV.CFG.get("conversation_window_s", 12)))
check("LOOP: retired knobs gone; window/pause/history/min-chars present",
      "ambient_mode" not in JV.CFG and "idle_timeout_s" not in JV.CFG
      and all(k in JV.CFG for k in ("conversation_window_s", "post_speech_pause_s",
                                    "history_turns", "min_command_chars")))


# 1) TTS -> WAV
import soundfile as sf
from kokoro_onnx import Kokoro
k = Kokoro(MODELS + "/kokoro-v1.0.onnx", MODELS + "/voices-v1.0.bin")
samples, sr = k.create(PHRASE, voice="bm_george", speed=1.0, lang="en-us")
wav = os.path.join(tempfile.gettempdir(), "jarvis_voice_selftest.wav")
sf.write(wav, samples, sr)
check("TTS: Kokoro synthesizes non-empty audio", len(samples) > 1000 and sr == 24000)

# 2) STT round-trip
from faster_whisper import WhisperModel
w = WhisperModel("small.en", device="cpu", compute_type="int8")
segs, _ = w.transcribe(wav)
heard = " ".join(s.text for s in segs).strip().lower()
check(f"STT: faster-whisper recovers the words (heard: {heard!r})",
      "jarvis" in heard and "online" in heard)

# 3) wake word
try:
    from openwakeword import utils as u
    u.download_models()
    from openwakeword.model import Model
    m = Model(wakeword_models=["hey_jarvis"])
    check("WAKE: openWakeWord 'hey_jarvis' loads (offline, keyless)",
          "hey_jarvis" in m.models)
except Exception as e:
    check(f"WAKE: openWakeWord 'hey_jarvis' loads ({e})", False)

# 3b) wake word FIRES on synthesized "hey jarvis" - the strongest wake diagnosis
# possible without a live mic (TTS audio -> resample to oww's 16 kHz int16 frames)
try:
    import numpy as np
    ws, wsr = k.create("Hey, Jarvis!", voice="bm_george", speed=1.0, lang="en-us")
    t = np.arange(0, len(ws) / wsr, 1 / 16000.0)
    s16 = np.interp(t, np.arange(len(ws)) / wsr, ws)
    pcm = (np.clip(s16, -1, 1) * 32767).astype(np.int16)
    pcm = np.concatenate([np.zeros(16000, np.int16), pcm, np.zeros(8000, np.int16)])
    peak = 0.0
    for i in range(0, len(pcm) - 1280, 1280):
        peak = max(peak, float(m.predict(pcm[i:i + 1280])["hey_jarvis"]))
    check(f"WAKE: synthesized 'hey jarvis' fires the model (peak={peak:.2f})", peak >= 0.5)

    # 3c) the barge-in detector (ADR-035) triggers on the same synthesized audio
    import jarvis_bargein as BI
    lst = BI.InterruptListener(sensitivity=0.6)
    for i in range(0, len(pcm) - 1280, 1280):
        lst.feed(pcm[i:i + 1280])
    check("BARGE: InterruptListener triggers on synthesized wake word",
          lst.triggered.is_set())
    lst.model.reset(); lst.triggered.clear()
    noise = (np.random.default_rng(7).normal(0, 900, 16000 * 3)).astype(np.int16)
    for i in range(0, len(noise) - 1280, 1280):
        lst.feed(noise[i:i + 1280])
    check("BARGE: InterruptListener ignores 3s of room-noise audio",
          not lst.triggered.is_set())
except Exception as e:
    check(f"WAKE: synthesized wake audio ({e})", False)

# 4) audio devices visible
import sounddevice as sd
ins = [d for d in sd.query_devices() if d["max_input_channels"] > 0]
outs = [d for d in sd.query_devices() if d["max_output_channels"] > 0]
check(f"AUDIO: input device present ({len(ins)})", len(ins) > 0)
check(f"AUDIO: output device present ({len(outs)})", len(outs) > 0)

print(f"\n{'VOICE HEADLESS VALIDATED' if fails == 0 else str(fails)+' FAILED'}"
      " - live spoken loop is the operator's physical test.")
sys.exit(fails)
