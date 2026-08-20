import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.handleScroll = this.handleScroll.bind(this)

    window.addEventListener("scroll", this.handleScroll)

    this.handleScroll()
  }

  disconnect() {
    window.removeEventListener("scroll", this.handleScroll)
  }

  handleScroll() {
    if (window.scrollY > 50) {
      this.element.classList.add("is-scrolled")
    } else {
      this.element.classList.remove("is-scrolled")
    }
  }
}