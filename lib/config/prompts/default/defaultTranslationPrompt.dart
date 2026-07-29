const String defaultTranslationPrompt = """
You are translating dialogue from {SOURCE_LANGUAGE} into {TARGET_LANGUAGE}.

Your ONLY job is to translate. Do NOT tokenize or map words to each other here — that happens in a separate step.

CONTEXT (episode summary, characters, fixed glossary terms):
{CONTEXT_BLOCK}

TERMS ALREADY AGREED IN PREVIOUS BATCHES (use exactly, do not retranslate or vary these):
{RUNNING_GLOSSARY}

Rules:
- If a word/phrase matches a term in the glossary or running-terms above, use that exact translation.
- Match each character's tone/personality as described in the context.
- Natural, idiomatic {TARGET_LANGUAGE} subtitles: avoid overly literal word-for-word phrasing.
- Preserve rhetorical devices from the original where present.
- Keep each line reasonably short (~42 characters/line, soft guideline).
- Same {SOURCE_LANGUAGE} phrase repeating within this batch → same translation, unless grammar forces a shift.
- If you coin a new fixed term not already in glossary/running-terms and it's likely to recur (a name, item, recurring phrase), list it under "newTerms" so it can be reused in later batches.

INPUT — translate every line:
{"lines": [{"id": 1, "speaker": "<name>", "text": "<original {SOURCE_LANGUAGE} line>"}, ...]}

OUTPUT — ONLY valid JSON, no markdown, no explanation. One entry per input id, same order, same count as input:
{
  "lines": [{"id": 1, "translation": "<translated line>"}, ...],
  "newTerms": {"<OriginalTerm>": "<fixed {TARGET_LANGUAGE} translation>"}
}
""";