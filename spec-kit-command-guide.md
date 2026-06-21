# Spec Kit Command Guide

このガイドは、Spec Kit で利用できるコマンドを、実際の開発ユースケースに沿って使い分けられるように整理したものです。

## 想定ユースケース

- ユーザー要望から仕様を作る
- 仕様を技術計画に落とし込む
- 実装タスクを生成して実装を進める
- 実装後の取りこぼしを検知し、必要なら GitHub Issue 化する

## まず押さえる標準フロー

1. /speckit.constitution
2. /speckit.specify
3. /speckit.clarify（必要な場合）
4. /speckit.plan
5. /speckit.tasks
6. /speckit.analyze（推奨）
7. /speckit.implement
8. /speckit.converge（必要な場合）
9. /speckit.taskstoissues（Issue 運用する場合）

## コマンド一覧（ユースケース別）

| コマンド | どんな時に使うか（実ユースケース） | 何をしてくれるか | 代表的な入力例 | 主な成果物・結果 |
|---|---|---|---|---|
| /speckit.constitution | チームの開発原則を最初に定めたい時。例: テスト方針、依存関係方針、品質基準を固定したい。 | プロジェクト原則を作成・更新し、テンプレート整合も確認。 | 品質重視。不要な依存は避け、テスト容易性を優先。 | .specify/memory/constitution.md |
| /speckit.specify | 要望文から仕様を起こしたい時。例: ToDo アプリ機能を要件化したい。 | 自然言語から spec.md を生成し、要件を構造化。 | タスク追加・完了・削除ができる ToDo アプリを作る。 | specs/配下の spec.md |
| /speckit.clarify | 仕様に曖昧さが残っている時。例: 権限、例外時挙動、性能目標が未確定。 | 高影響な不明点を質問し、仕様へ反映。 | 認証方式はメールリンク認証を採用。 | spec.md の Clarifications 反映 |
| /speckit.plan | 実装前に技術設計を固めたい時。例: 技術スタック、データ構造、検証手順を確定。 | 設計アーティファクト一式を生成。 | フロントは Vanilla JS、保存は localStorage。 | plan.md, research.md, data-model.md, quickstart.md, contracts/ |
| /speckit.agent-context.update | plan の保存先が更新され、エージェント参照先も同期したい時。 | コーディングエージェント向けコンテキストの管理ブロックを更新。 | 最新 plan 参照に更新して。 | .github/copilot-instructions.md の管理セクション更新 |
| /speckit.tasks | 実装可能な粒度にタスク分解したい時。例: フェーズ順、依存順、並列可能タスクを明確化。 | tasks.md を依存関係つきで生成。 | MVP 先行で、P1 から着手できるタスクに分解。 | tasks.md |
| /speckit.analyze | 実装前に仕様・計画・タスクの整合を検査したい時。 | spec/plan/tasks を横断分析し、矛盾や不足を指摘。 | 実装前レビューとして整合性チェックしたい。 | 分析レポート（読み取り専用） |
| /speckit.implement | tasks.md に沿って実装を進めたい時。例: 仕様駆動で段階実装。 | タスク順に実装を進め、完了済みタスクを更新。 | tasks.md の全タスクを実行。 | 実装コード、tasks.md の進捗反映 |
| /speckit.converge | 一度実装した後、取りこぼしを追加抽出したい時。 | 現在コードと spec/plan/tasks の差分を評価し、残作業を tasks.md に追記。 | 未実装項目を再抽出して追加して。 | tasks.md に Convergence フェーズ追加 |
| /speckit.checklist | 実装テストではなく、要件記述品質を点検したい時。 | 要件の明確性・完全性・測定可能性を確認するチェックリストを生成。 | セキュリティ観点の要件品質チェックを作成。 | checklists/*.md |
| /speckit.taskstoissues | タスク管理を GitHub Issues へ移行したい時。 | tasks.md を重複検知つきで Issue 化。 | 未作成タスクだけ Issue 化して。 | GitHub Issues 作成結果 |

## 実戦シナリオ 1: 新機能をゼロから作る

1. /speckit.constitution
2. /speckit.specify
3. /speckit.clarify
4. /speckit.plan
5. /speckit.tasks
6. /speckit.implement

効果:
- 仕様から実装までの流れを一本化できる
- 曖昧さを early に潰して手戻りを減らせる

## 実戦シナリオ 2: 実装前の品質ゲートを強化する

1. /speckit.specify
2. /speckit.clarify
3. /speckit.plan
4. /speckit.tasks
5. /speckit.analyze

効果:
- タスク漏れ・要件矛盾を実装前に発見できる
- 仕様品質の合意形成がしやすくなる

## 実戦シナリオ 3: 実装済み機能の取りこぼしを回収する

1. /speckit.implement
2. /speckit.converge
3. /speckit.implement
4. /speckit.taskstoissues（必要時）

効果:
- 実装ギャップを継続的に減らせる
- GitHub 上の実行計画と同期しやすい

## 使い分けのコツ

- 仕様が曖昧なら /speckit.clarify を先に実行
- 実装前の最終確認には /speckit.analyze を挟む
- 実装後に未達が出る前提で /speckit.converge をループに入れる
- タスクをチーム運用するなら /speckit.taskstoissues で Issue 化する
