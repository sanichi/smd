import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "email" ]

  copy() {
    navigator.clipboard.writeText(this.emailTarget.value);
    this.element.lastElementChild.innerText = "Copied";
  }
}
