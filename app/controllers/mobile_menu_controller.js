import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "button"]

  toggle() {
    this.menuTarget.classList.toggle("is-open")

    const isOpen = this.menuTarget.classList.contains("is-open")

    this.buttonTarget.setAttribute("aria-expanded", isOpen)
  }
}