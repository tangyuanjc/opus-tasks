#!/bin/bash
# AutoLoop飞书通知脚本
# 每1小时检查GitHub Issues状态变化并通知jc

# 设置PATH确保能找到命令
export PATH="/opt/homebrew/bin:$PATH"

REPO="tangyuanjc/opus-tasks"
LAST_CHECK_FILE="$HOME/opus-tasks/.last-check"

# 获取上次检查时间
if [ -f "$LAST_CHECK_FILE" ]; then
  LAST_CHECK=$(cat "$LAST_CHECK_FILE")
else
  LAST_CHECK=$(date -u -v-1H +"%Y-%m-%dT%H:%M:%SZ")
fi

# 更新检查时间
date -u +"%Y-%m-%dT%H:%M:%SZ" > "$LAST_CHECK_FILE"

# 获取最近更新的issues
gh issue list --repo "$REPO" --limit 50 --json number,title,labels,updatedAt,state --jq ".[] | select(.updatedAt > \"$LAST_CHECK\")" > /tmp/updated-issues.json

# 如果有更新，发送飞书通知
if [ -s /tmp/updated-issues.json ]; then
  while IFS= read -r issue; do
    number=$(echo "$issue" | jq -r '.number')
    title=$(echo "$issue" | jq -r '.title')
    state=$(echo "$issue" | jq -r '.state')
    labels=$(echo "$issue" | jq -r '.labels[].name' | tr '\n' ',' | sed 's/,$//')

    # 构建通知消息
    if echo "$labels" | grep -q "verified"; then
      emoji="✅"
      status="验证通过"
    elif echo "$labels" | grep -q "needs-decision"; then
      emoji="❌"
      status="需要决策"
    elif echo "$labels" | grep -q "retry:"; then
      retry=$(echo "$labels" | grep -o "retry:[0-9]" | cut -d: -f2)
      emoji="⚠️"
      status="重试 $retry/3"
    else
      emoji="💬"
      status="更新"
    fi

    message="$emoji Issue #$number $status

$title

标签: $labels
状态: $state
链接: https://github.com/$REPO/issues/$number"

    # 发送飞书消息
    lark-cli im +messages-send --as bot --user-id ou_a06ae3d7885f83839917ac0f44e46247 --text "$message"

  done < /tmp/updated-issues.json
fi
