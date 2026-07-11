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
fails = 0
MODELS = r"D:/Fable OS/config/voice/models"
PHRASE = "The Jarvis runtime is now online."


def check(name, ok):
    global fails
    print(f"  {'PASS' if ok else 'FAIL'}  {name}")
    if not ok:
        fails += 1


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

# 4) audio devices visible
import sounddevice as sd
ins = [d for d in sd.query_devices() if d["max_input_channels"] > 0]
outs = [d for d in sd.query_devices() if d["max_output_channels"] > 0]
check(f"AUDIO: input device present ({len(ins)})", len(ins) > 0)
check(f"AUDIO: output device present ({len(outs)})", len(outs) > 0)

print(f"\n{'VOICE HEADLESS VALIDATED' if fails == 0 else str(fails)+' FAILED'}"
      " - live spoken loop is the operator's physical test.")
sys.exit(fails)
