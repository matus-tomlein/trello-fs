require 'spec_helper'

describe TrelloFs::TrelloApi do

  let(:repository) { TestRepository.new }
  let(:trello_api) { TrelloFs::TrelloApi.new(repository) }

  before :each do
    allow(trello_api).to receive(:download_board_json) { response_body }
  end

  describe '#board' do
    let(:board) { trello_api.board('2174981360244') }
    it { expect(board.name).to eq 'Board Name' }
    it { expect(board.desc).to eq 'Board Description' }
    it { expect(board.organization_name).to eq 'Matus PhD' }
    it { expect(board.lists.size).to eq 1 }
    # it { expect(repository.attachments.size).to eq 1 }

    let(:list) { board.lists.first }
    it { expect(list.name).to eq 'List Name' }
    it { expect(list.cards.size).to eq 1 }

    let(:card) { list.cards.first }
    it { expect(card.name).to eq 'Card Name' }
    it { expect(card.desc).to eq 'Card Description' }
    it { expect(card.short_link).to eq 'short_link' }
    it { expect(card.checklists.size).to eq 1 }
    it { expect(card.attachments.size).to eq 1 }

    let(:checklist) { card.checklists.first }
    it { expect(checklist.name).to eq 'Checklist' }
    it { expect(checklist.items.size).to eq 1 }

    let(:checklist_item) { checklist.items.first }
    it { expect(checklist_item.name).to eq 'Checklist Item 1' }
    it { expect(checklist_item.state).to eq 'incomplete' }
  end

  def response_body
    {
      "id" => "2174981360244",
      "name" => "Board Name",
      "desc" => "Board Description",
      "descData" => nil,
      "closed" => false,
      "idOrganization" => nil,
      "pinned" => false,
      "url" => "https://trello.com/b/Wccvd/board",
      "shortUrl" => "https://trello.com/b/Wccvd",
      "organization" => {
        "id" => "264631916292bb8",
        "name" => "matusphd",
        "displayName" => "Matus PhD"
      },
      "prefs" => {
      },
      "labelNames" => {
        "green" => "", "yellow" => "", "orange" => "", "red" => "", "purple" => "", "blue" => "", "sky" => "", "lime" => "", "pink" => "", "black" => ""
      },
      "labels" => [
        {
          "id" => "546da5df74d650d56751d2f7",
          "idBoard" => "546da5dfc9c189f852060244",
          "name" => "Label 1",
          "color" => "green",
          "uses" => 1
        }
      ],
      "cards" => [
        {
          "id" => "546da5f05906d2a063bbea85",
          "checkItemStates" => [],
          "closed" => false,
          "dateLastActivity" => "2014-11-20T08:28:18.936Z",
          "desc" => "Card Description",
          "descData" => nil,
          "email" => nil,
          "idBoard" => "546da5dfc9c189f852060244",
          "idList" => "546da5e83fa3907212a5eed1",
          "shortLink" => "short_link",
          "idMembersVoted" => [],
          "idShort" => 1,
          "idAttachmentCover" => nil,
          "manualCoverAttachment" => false,
          "idLabels" => [
            "546da5df74d650d56751d2f7"
          ],
          "name" => "Card Name",
          "labels" => [
            {
              "id" => "546da5df74d650d56751d2f7",
              "idBoard" => "546da5dfc9c189f852060244",
              "name" => "Label 1",
              "color" => "green",
              "uses" => 1
            }
          ],
          "shortUrl" => "https://trello.com/c/il3oSldG",
          "subscribed" => false,
          "url" => "https://trello.com/c/il3oSldG/1-20-11-2014",
          "checklists" => [
            {
              "id" => "546da60b9446036c5a6241bd",
              "name" => "Checklist",
              "idBoard" => "546da5dfc9c189f852060244",
              "idCard" => "546da5f05906d2a063bbea85",
              "pos" => 16384,
              "checkItems" => [
                {
                  "id" => "546da6182183e3d2a1a0e4ab",
                  "name" => "Checklist Item 1",
                  "nameData" => nil,
                  "pos" => 17229,
                  "state" => "incomplete"
                }
              ]
            }
          ],
          "attachments" => [
            {
              "bytes" => 262233,
              "date" => "2015-02-21T17:00:54.423Z",
              "edgeColor" => nil,
              "idMember" => "ead2c755d8a670dac6d",
              "isUpload" => true,
              "mimeType" => nil,
              "name" => "main.pdf",
              "previews" => [],
              "url" => "https://trello-attachments.s3.amazonaws.com/546da9f852060244/54a85/19/main.pdf",
              "id" => "70816dbd5085cee"
            }
          ]
        }
      ],
      "lists" => [
        {
          "id" => "546da5e83fa3907212a5eed1",
          "name" => "List Name",
          "closed" => false,
          "idBoard" => "546da5dfc9c189f852060244",
          "pos" => 65535,
          "subscribed" => false
        }
      ]
    }
  end
end
