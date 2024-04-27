import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "local_time" ]
  connect() {
    if (this.local_timeTarget) {
      this.local_timeTarget.innerHTML += ("&nbsp;" + moment.tz.guess());
    }
  }
}
