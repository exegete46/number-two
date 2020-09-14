// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="chat">
//   <h1 data-target="chat.output"></h1>
// </div>

import { Controller } from "stimulus"
import { chatOverlayMessagesChannel } from "../channels/chat_overlay_messages_channel"

export default class extends Controller {
  static targets = ['messages']

  connect() {
    chatOverlayMessagesChannel.received = (data) => {
      this.messagesTarget.insertAdjacentHTML('beforeend', data)
    }
  }
}