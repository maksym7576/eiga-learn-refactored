import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Спільний контракт для будь-якого "пошук -> список -> (опційно деталі) -> OK".
///
/// TEntry — тип елемента верхнього списку (тайтл / рядок тексту / щось інше)
/// TFile  — тип елемента другого рівня, якщо він є (файл субтитрів, конкретна
///          знахідка в тексті і т.д.). Якщо другого рівня нема — став TFile = Never
///          і hasFileStage = false, TFile просто не використовується.
///
/// ВАЖЛИВО: search / getFiles / resolve отримують [WidgetRef] — саме через нього
/// джерело має діставати свої сервіси (наприклад `ref.read(jimakuServiceProvider.future)`),
/// а НЕ створювати їх напряму (`JimakuService.create()`). Використовуємо саме
/// WidgetRef (а не Ref), бо в Riverpod 2.x WidgetRef НЕ є підтипом Ref, а ці
/// методи завжди викликаються з ConsumerState/ConsumerWidget, де є WidgetRef.
/// Це дає:
///  - єдину точку створення/кешування сервісу (провайдер),
///  - можливість підмінити сервіс у тестах через ProviderScope(overrides: ...),
///  - консистентність з рештою Riverpod-архітектури.
abstract class SearchSource<TEntry, TFile> {
  /// Унікальний ключ — на ньому будуються провайдери (щоб різні джерела
  /// не ділили один стейт, навіть якщо відкриті "одночасно" в різних місцях UI)
  String get key;

  String get title;
  String get searchHint;

  /// true  -> дворівневий флоу (Jimaku: тайтл -> файли)
  /// false -> entry сам по собі є фінальним результатом (напр. пошук тексту)
  bool get hasFileStage;

  /// Початкові фільтри цього джерела (кожне джерело має свою форму фільтрів)
  Map<String, dynamic> get defaultFilters;

  /// [ref] — звідси дістаємо сервіс(и), потрібні для запиту
  /// (наприклад `await ref.read(jimakuServiceProvider.future)`).
  Future<List<TEntry>> search(
      String query,
      Map<String, dynamic> filters,
      WidgetRef ref,
      );

  /// Викликається тільки якщо hasFileStage == true.
  /// [ref] — так само, для доступу до сервісу через провайдер.
  Future<List<TFile>> getFiles(
      TEntry entry,
      Map<String, dynamic> filters,
      WidgetRef ref,
      ) =>
      Future.value(const []);

  /// Перетворює фінально обране (entry, якщо !hasFileStage, або file, якщо
  /// hasFileStage) на кінцевий результат — шлях до файлу, ID, що завгодно.
  /// [ref] — так само, для доступу до сервісу через провайдер.
  Future<String> resolve(dynamic selected, WidgetRef ref);

  /// Панель фільтрів під пошуковим полем. Читає/пише через searchFiltersProvider(key).
  Widget buildFilterBar(BuildContext context, WidgetRef ref);

  Widget buildEntryCard(TEntry entry, bool isActive, VoidCallback onTap);

  Widget buildFileCard(TFile file, bool isActive, VoidCallback onTap) =>
      const SizedBox.shrink();

  String entryId(TEntry entry);
  String fileId(TFile file);

  /// Текст для breadcrumb на сторінці "деталей" (Jimaku: entry.displayTitle,
  /// пошук тексту: можна повернути сам сніпет чи ID — не критично, бо для
  /// hasFileStage == false ця сторінка взагалі не показується).
  String entryLabel(TEntry entry);
}