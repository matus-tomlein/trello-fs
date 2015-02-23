require_relative '../lib/trello-fs'

TrelloFs.build({
  path: 'boards',
  title: 'Examples',
  description: 'Sample boards exported from Trello.',
  developer_public_key: 'f19ae1a07b4a7112b3227bb6fd99abec',
  member_token: 'cf2db23395ea7d0507930218eaec1e4b2f1783b9e6798be92b601f429de517cd',
  board_ids: ['54e8e79e3bebac45c537327c', '54e79539bda3e89c0bf454ec']
})
