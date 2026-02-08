

const String defaultPrompt = """
STEP 1: Translate the full sentence naturally in {TARGET_LANGUAGE} (native grammar & structure).

STEP 2: Match original words to translation:
- Take 1st word → find its meaning in translation
- Not found? Take 2nd word with it → search meaning
- Still not found? Take 3rd word → search (max 3 words per block)
- Create block and assign positions

JSON FORMAT:
{
  "phraseId": <id>,
  "blocks": [
    {
      "word": [
        {"original": "word", "w_pos": <position>}
      ],
      "tr": "translation",
      "tr_pos": <position in {TARGET_LANGUAGE}>,
      "b_pos": <position in {SOURCE_LANGUAGE}>
    }
  ]
}

RULES:
- Include ALL original words (no deletions)
- NO empty "tr" values or null "tr_pos".
- Combine words only when meaning requires it
- tr_pos = word order in {TARGET_LANGUAGE}
- w_pos = sequential count in {SOURCE_LANGUAGE}
- NO kana/romaji fields
""";