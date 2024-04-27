import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  language() {
    this.element.requestSubmit();
  }
}