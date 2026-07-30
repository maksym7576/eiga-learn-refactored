# Fix Romaji Display and Prompt Inconsistency (Rename romanji -> romaji)

The user wants to rename all occurrences of `romanji` to `romaji`. This fixes a typo in the Japanese generation prompt and ensures consistency across the application.

## User Review Required

> [!IMPORTANT]
> This change includes:
> 1. Fixing the typo in the AI prompt.
> 2. Adding normalization to handle existing data in the database that might still use the `romanji` key.
> 3. Ensuring the UI can look up either key for backward compatibility.

## Proposed Changes

### [Prompt Configuration]

#### [MODIFY] [japaneseTotalPrompt.dart](file:///C:/Users/fcjhx/StudioProjects/eiga-learn-refactored/lib/config/prompts/japanese/japaneseTotalPrompt.dart)
- Rename all `romanji` occurrences to `romaji`.

### [Data Parsing & Normalization]

#### [MODIFY] [geminiStreamingService.dart](file:///C:/Users/fcjhx/StudioProjects/eiga-learn-refactored/lib/backend/services/petition_ai/gemini/geminiStreamingService.dart)
- Update `_normalizeWordVersions` to normalize `romanji` key to `romaji`.

#### [MODIFY] [PhraseResponseHandler.dart](file:///C:/Users/fcjhx/StudioProjects/eiga-learn-refactored/lib/backend/services/petition_ai/parsers/PhraseResponseHandler.dart)
- Update `_processPhraseEntry` to normalize `romanji` key to `romaji`.

### [UI Components]

#### [MODIFY] [phraseTranslatedWidget.dart](file:///C:/Users/fcjhx/StudioProjects/eiga-learn-refactored/lib/ui/widgets/phrasesCardsWidgest/phraseTranslatedWidget.dart)
- Update `_getVersionText` to fallback to `romanji` if `romaji` is not found, ensuring existing data continues to work.

## Verification Plan

### Manual Verification
- Verify that selecting "romaji" in settings now correctly shows the text even for older entries.
- Verify that new entries are generated with the correct `romaji` key.
