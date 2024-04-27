import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  show_hidden() {
    $('a').css({ display: "" });
    $('i.fa').css({ display: "" });
    $('div.a').css({ display: "" });
  }
}
