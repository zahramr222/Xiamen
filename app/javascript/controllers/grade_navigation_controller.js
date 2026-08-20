import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  connect() {
    this.updateActiveLink()
    document.addEventListener("scroll", this.updateActiveLink.bind(this))
  }

  disconnect() {
    document.removeEventListener("scroll", this.updateActiveLink.bind(this))
  }

  updateActiveLink() {
    const scrollPosition = window.scrollY + 150
    let currentSection = "overview"

    // Find which section is currently in view
    this.linkTargets.forEach(link => {
      const sectionId = link.dataset.section
      const section = document.getElementById(sectionId)
      if (section && scrollPosition >= section.offsetTop) {
        currentSection = sectionId
      }
    })

    // Update active class
    this.linkTargets.forEach(link => {
      link.classList.toggle("active", link.dataset.section === currentSection)
    })
  }
}