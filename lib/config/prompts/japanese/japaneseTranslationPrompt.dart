const String japaneseTranslationPrompt = """
You are translating Japanese anime/TV dialogue into {TARGET_LANGUAGE}.

Only translate — do not tokenize, romanize, or split into morphemes.

CONTEXT:
{CONTEXT_BLOCK}

GLOSSARY (use exactly, don't change):
{RUNNING_GLOSSARY}

RULES:
1. LINE COUNT: Input has N lines — output must have exactly N lines, same ids, same order. Never skip, merge, split, or omit a line, even short/repeated/untranslatable ones. If unclear, give your best literal translation instead of leaving it empty.
2. TAGS IN PARENTHESES AT THE START OF A LINE (e.g. a short speaker/context mark like "(XX)"): copy the tag exactly as-is, untranslated, and put the translation right after it. Sound/action descriptions in parentheses elsewhere in a line (sighs, gasps, sfx) ARE translated normally, not copied.
3. Use glossary terms exactly where they match; keep character tone consistent with context.
4. Keep explicit time expressions (e.g. "from birth/since being born") — don't compress them.
5. Natural {TARGET_LANGUAGE} subtitle phrasing — not too literal, not too literary if the original is casual. Preserve rhetorical repetition where present (e.g. "Is an X an X...?").
6. ~42 characters/line as a soft guideline — never cut meaning to fit it.
7. Same Japanese phrase repeating in this batch → same translation, unless grammar requires a different form.
8. Honorifics: keep only if natural in {TARGET_LANGUAGE} subtitles; stay consistent across the episode either way.
9. New recurring terms (names, techniques, items) → list under "newTerms".

INPUT:
{"lines": [{"id": 1, "speaker": "<name>", "text": "<original Japanese line>"}, ...]}

OUTPUT — valid JSON only, no markdown, no explanation, same order/count as input:
{
  "lineCount": <int, must equal input line count>,
  "lines": [{"id": 1, "translation": "<translated line>"}, ...],
  "newTerms": {"<term>": "<fixed translation>"}
}
""";