TrelloFs
========

Dumps the contents of Trello boards into a folder structure.
The generated files can be then pushed to Github or a Bitbucket Wiki.

# Example

See the [demo boards](examples/boards/README.md), which were generated
from these Trello boards:
[https://trello.com/b/23HXX6Gr/trellofs-demo-board](https://trello.com/b/23HXX6Gr/trellofs-demo-board)
[https://trello.com/b/bkskcUIO/welcome-board](https://trello.com/b/bkskcUIO/welcome-board)

# Features

- compatible with Github and Bitbucket Wiki
- supports attachments
- shows image attachments directly in the card view
- label files that contain references to cards with the labels
- supports updating the repository
- downloads the same attachments only once
- replaces links to cards in the exported boards with local links

# Installation

1. Install the gem

  ```
  gem install trello-fs
  ```

2. Create a file like this one:

  ```
  require 'trello-fs'

  TrelloFs.build({
    title: 'Some Title',
    description: 'Some Description',
    path: 'PATH_TO_THE_TARGET_FOLDER',
    developer_public_key: 'DEVELOPER_PUBLIC_KEY',
    member_token: 'MEMBER_TOKEN',
    board_ids: ['BOARD_ID']
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
