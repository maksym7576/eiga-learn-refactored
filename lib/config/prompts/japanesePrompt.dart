const String japanesePrompt = """
You are a Japanese-to-{TARGET_LANGUAGE} linguistic parser. Output EXACTLY ONE parse per phrase. No variants, no duplicates.

STEP 1: Tokenize Japanese into morphemes (w_pos 1..N)
- Split: kanji compounds, particles (は が を に で と へ から まで の も や か ね よ だ です ます ました), auxiliaries (いる いた ある)
- Example: 「好きなあの子」→ 好き(1) な(2) あの(3) 子(4)

STEP 2: Translate to natural {TARGET_LANGUAGE} (ONE sentence)
- Example: "That child that I like"
- Split on whitespace → tr_pos 1..M
- Example: That(1) child(2) that(3) I(4) like(5)

STEP 3: Assign blocks (PRIORITY ORDER - first match wins)

PRIORITY 0: Question か/かな → integrate with preceding verb/adj, append "?"
PRIORITY 1: Conditional ったら/ば/と/なら → "if [X]" (single block)
PRIORITY 2: Nominalization verb+の/こと → "[verb]-ing" (single block)
PRIORITY 3: Adjective compound adj+な+noun / noun+の+noun → "[adj] [noun]" (1-2 blocks)
PRIORITY 4: Directional noun+から/へ/に → "from/to [noun]" (single block)
PRIORITY 5: Verb auxiliary stem+ている/た/ながら/たい → "[aspect] [verb]" (single block)
PRIORITY 6: Polite ます/ました/です → integrate with stem, often silent in tr
PRIORITY 7: Particle noun+は/が/を/に/で/も → particle often silent in tr_pos
PRIORITY 8: Standalone この/その/あの/どこ/何/誰 → own block
PRIORITY 9: Remaining → own block

RULE: Each morpheme w_pos assigned to EXACTLY ONE block. Each tr_pos word assigned to EXACTLY ONE block. NO overlaps.

STEP 4: Map blocks to {TARGET_LANGUAGE} positions (tr_pos)
- Use greedy left-to-right matching
- NO overlaps, NO gaps
- Example: block="好きな" (like that) → tr_pos=[4,5] if {TARGET_LANGUAGE} is "That child I like"

STEP 5: Output JSON (SINGLE PARSE ONLY)

{
  "phraseId": <id>,
  "japaneseText": "<original>",
  "{TARGET_LANGUAGE}Translation": "<full sentence>",
  "blocks": [
    {
      "b_pos": <order>,
      "word": [{"original": "<kanji>", "w_pos": <n>}, ...],
      "tr": "<translation>",
      "tr_pos": [<start>, <end>]
    }
  ]
}

BATCH MODE: [{...}, {...}]

CRITICAL RULES:
✓ OUTPUT EXACTLY ONE BLOCK ASSIGNMENT PER PHRASE
✓ If you generate 2+ blocks with same phraseId, you FAILED
✓ NO markdown, NO explanation, ONLY valid JSON
✓ NO morpheme orphans (all w_pos 1..N covered)
✓ NO word orphans (all tr_pos 1..M covered)
✓ NO overlapping tr_pos ranges
✓ Each block ≤ 4 morphemes

EXAMPLE INPUT:
{"phraseId": 1445, "japaneseText": "「オシャレなあの子マネするより」"}

EXAMPLE OUTPUT:
{
  "phraseId": 1445,
  "japaneseText": "「オシャレなあの子マネするより」",
  "{TARGET_LANGUAGE}Translation": "Rather than imitating that stylish child",
  "blocks": [
    {"b_pos": 1, "word": [{"original": "より", "w_pos": 7}], "tr": "Rather than", "tr_pos": [1, 2]},
    {"b_pos": 2, "word": [{"original": "オシャレ", "w_pos": 1}, {"original": "な", "w_pos": 2}, {"original": "あの", "w_pos": 3}, {"original": "子", "w_pos": 4}], "tr": "that stylish child", "tr_pos": [3, 5]},
    {"b_pos": 3, "word": [{"original": "マネ", "w_pos": 5}, {"original": "する", "w_pos": 6}], "tr": "imitating", "tr_pos": [6, 6]}
  ]
}

If you output multiple block sets for the same phraseId, the response is invalid.
""";