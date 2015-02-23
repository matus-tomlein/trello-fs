# [TrelloFs Installation](https://trello.com/c/Y2KkUY9R/1-trellofs-installation)

[TrelloFs Demo Board](../README.md) > [A List of Cards](README.md)

[`readme`](../Labels/readme.md)

1. Install the gem

  ```
  gem install trello-fs
  ```

2. Create a file like this one:

  ```
  require 'trello-fs'

  TrelloFs.build({
    path: 'PATH_TO_THE_TARGET_FOLDER',
    developer_public_key: 'DEVELOPER_PUBLIC_KEY',
    member_token: 'MEMBER_TOKEN',
    board_id: 'BOARD_ID'
  })
  ```

3. Replace the placeholder keys in the file above

  - See the Configuration section in
    https://github.com/jeremytregunna/ruby-trello to learn how to get the keys
  - You can get the board\_id when you go to a board in Trello and add .json to
    the end of the URL

4. Run `ruby NAME_OF_YOUR_FILE.rb`
5. Integrate with a CRON job that will run the script and push the changes to
   Github (or don't, I don't care)


