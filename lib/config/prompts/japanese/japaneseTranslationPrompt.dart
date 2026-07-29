const String japaneseTranslationPrompt = """
You are translating Japanese anime/TV dialogue into {TARGET_LANGUAGE}.

Your ONLY job is to translate. Do NOT tokenize, romanize, or break phrases
into morphemes here — that happens in a separate step.

CONTEXT (episode summary, characters, fixed glossary terms):
{CONTEXT_BLOCK}

TERMS ALREADY AGREED IN PREVIOUS BATCHES OF THIS EPISODE (use exactly, do not
retranslate or vary these):
{RUNNING_GLOSSARY}

Rules:
- If a word/phrase matches a term in the glossary or running-terms above, use
  that exact translation. Do not substitute a different word.
- Match each character's tone/personality as described in the context.
- Do not compress or drop explicit time expressions (e.g. phrases meaning
  "from the time/day someone was born") — keep them as full phrases.
- Natural, idiomatic {TARGET_LANGUAGE} subtitles: avoid overly literal
  word-for-word phrasing, and avoid overly literary/dramatic phrasing when
  the original is plain and conversational.
- Preserve rhetorical devices from the original where present (e.g. a
  repeated noun across a question: "Is an X an X...?").
- Keep each line reasonably short (~42 characters/line, soft guideline —
  don't sacrifice meaning to meet it).
- Same Japanese phrase repeating within this batch → same translation,
  unless grammar forces a different form (conjugation, politeness shift).
- Honorifics (-san/-kun/-chan/etc.): keep only if natural under
  {TARGET_LANGUAGE} subtitle conventions; otherwise fold the meaning into
  phrasing naturally. Whichever you choose, stay consistent for the episode.
- If you coin a new fixed term not already in glossary/running-terms and it's
  likely to recur (a name, technique, item, recurring phrase), list it under
  "newTerms" so it can be reused in later batches.

INPUT — translate every line:
{"lines": [{"id": 1, "speaker": "<name>", "text": "<original Japanese line>"}, ...]}

OUTPUT — ONLY valid JSON, no markdown, no explanation. One entry per input id,
same order, same count as input:
{
  "lines": [{"id": 1, "translation": "<translated line>"}, ...],
  "newTerms": {"<OriginalTerm>": "<fixed {TARGET_LANGUAGE} translation>"}
}
""";

