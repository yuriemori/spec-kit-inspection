# Spec Kitのフロー


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

## GitHub Spec Kit Workflow（画像ベース解説）

画像のワークフローは、中央の Constitution（設計原則・開発標準）を軸に、周囲の 6 つのコマンドを順に回す「反復型サイクル」として表現されています。

| ステップ | コマンド | 主担当（画像の文脈） | 目的 | 主な出力 |
|---|---|---|---|---|
| 1 | `/speckit:specify` | PM | 何を作るか（ユーザー価値・機能要求）を定義する | `spec.md` |
| 2 | `/speckit:clarify` | PM + Architect | 曖昧さ・未確定事項を解消し、仕様を明確化する | 更新された `spec.md` |
| 3 | `/speckit:plan` | Architect | どう作るか（技術方針・構成・実装戦略）を設計する | `plan.md`、`research.md` など |
| 4 | `/speckit:tasks` | SWE + Delivery Lead | 実装可能な単位に分割し、依存順を整理する | `tasks.md` |
| 5 | `/speckit:analyze` | Architect + PM + SWEs | spec/plan/tasks の整合性や不足を検査し、改善点を出す | 改善提案、必要なら成果物更新 |
| 6 | `/speckit:implement` | SWEs + Coding Agents | タスクに沿って実装・テストを進める | コード、テスト、実装差分 |

### 中央にある Constitution の意味

- Constitution は「このプロジェクトで守る設計原則・品質基準・開発規約」の共通土台です。
- 6 ステップすべての判断基準として機能し、仕様から実装までの一貫性を保ちます。
- 迷ったときは Constitution に立ち返ることで、チームと AI の判断を揃えられます。

### 実運用のポイント

- 一方向の直線工程ではなく、`analyze -> clarify/plan/tasks` へ戻る前提で回すと品質が上がります。
- `implement` 後は、テスト結果や差分レビューを踏まえて必要なら仕様・計画へフィードバックします。
- 小さな機能単位でこのサイクルを回すと、手戻りを抑えながら安定して前進できます。
