# Spec Kit Agent Guide

`specify init --integration copilot` で生成される `.github/agents` 配下のエージェント一覧です。

| Agent | 役割 | 使用用途（いつ使うか） |
|---|---|---|
| speckit.agent-context.update | コーディングエージェント向けコンテキストファイル（例: `.github/copilot-instructions.md`）の Spec Kit 管理セクションを更新する。最新の `specs/*/plan.md` 参照に同期する。 | 計画書の場所が変わったとき、または `/speckit.plan` 実行後にコンテキスト参照を最新化したいとき。 |
| speckit.analyze | `spec.md` / `plan.md` / `tasks.md` の整合性・曖昧さ・重複・不足を横断分析する（読み取り専用）。 | `/speckit.tasks` 実行後、実装前に仕様品質とタスク網羅性を点検したいとき。 |
| speckit.checklist | 要件記述の品質を検証するチェックリストを生成する（実装テストではなく、要件の明確性・完全性を検査）。 | 仕様レビュー前に「要件が十分に書けているか」を定型チェックしたいとき。 |
| speckit.clarify | 仕様の未確定点を質問で絞り込み、回答を `spec.md` に反映して曖昧さを減らす。 | `/speckit.plan` 前に、仕様の不明点や選択肢を確定して手戻りを減らしたいとき。 |
| speckit.constitution | プロジェクト原則（constitution）を作成・更新し、関連テンプレートとの整合を取る。 | 開発方針（品質・テスト・依存関係方針など）を明文化したいとき、または原則を改定したいとき。 |
| speckit.converge | 現在の実装と `spec.md` / `plan.md` / `tasks.md` の差分（未実装・不整合）を評価し、残作業を `tasks.md` に追記する。 | `/speckit.implement` 後に、取りこぼしタスクを再抽出して次の実装サイクルに繋げたいとき。 |
| speckit.implement | `tasks.md` を順に実行して実装を進める。依存関係・フェーズ・チェックリスト状態を考慮する。 | タスク定義が完了しており、実装フェーズを自動的に前進させたいとき。 |
| speckit.plan | 仕様を技術計画へ落とし込み、`plan.md`・`research.md`・`data-model.md`・`quickstart.md` など設計成果物を作る。 | `/speckit.specify` 後に、実装前の設計判断・構造化・検証手順を固めたいとき。 |
| speckit.specify | 自然言語の要望から機能仕様 `spec.md` を生成・更新する。 | 新機能の要求を仕様化したいとき（最初の仕様起点）。 |
| speckit.tasks | 設計成果物を基に、依存順・実行順を考慮した `tasks.md` を生成する。 | 実装開始前に、実行可能なタスク分解（フェーズ/並列可否/ファイル単位）を作りたいとき。 |
| speckit.taskstoissues | `tasks.md` のタスクを重複確認しながら GitHub Issue に変換する。 | タスクをリポジトリの Issue 管理へ移し、進行管理を GitHub 上で行いたいとき。 |

## 典型的な利用順

1. `speckit.constitution`
2. `speckit.specify`
3. `speckit.clarify`（必要時）
4. `speckit.plan`
5. `speckit.tasks`
6. `speckit.analyze`（推奨）
7. `speckit.implement`
8. `speckit.converge`（必要時）
9. `speckit.taskstoissues`（Issue 管理したい場合）
