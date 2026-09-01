import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    this.timeout = null
    console.log("SEARCH CONTROLLER CONNECTED")
    
    // Handle "/" key to focus search
    document.addEventListener("keydown", (event) => {
      if (event.key === "/" && document.activeElement.tagName !== "INPUT") {
        event.preventDefault()
        this.inputTarget.focus()
      }
    })
  }

  search() {
    console.log("SEARCH FUNCTION CALLED")

    clearTimeout(this.timeout)

    const query = this.inputTarget.value.trim()

    console.log("QUERY:", query)

    if (query.length < 3) {
      this.resultsTarget.innerHTML = ""
      this.resultsTarget.style.display = "none"
      return
    }

    this.timeout = setTimeout(() => {
      this.fetchResults(query)
    }, 250)
  }

  async fetchResults(query) {
    console.log("FETCHING:", query)

    try {
      const response = await fetch(
        `/search?q=${encodeURIComponent(query)}`,
        {
          headers: {
            Accept: "application/json"
          }
        }
      )

      console.log("RESPONSE STATUS:", response.status)

      if (!response.ok) {
        throw new Error("Search request failed")
      }

      const results = await response.json()

      console.log("RESULTS:", results)

      this.renderResults(results)

    } catch (error) {
      console.error("Search error:", error)
      this.resultsTarget.innerHTML = `<p class="search-error">Something went wrong. Please try again.</p>`
      this.resultsTarget.style.display = "block"
    }
  }

  renderResults(results) {
    if (!results || results.length === 0) {
      this.resultsTarget.innerHTML = `
        <p class="search-no-results">No results found for "<strong>${this.inputTarget.value}</strong>"</p>
      `
      this.resultsTarget.style.display = "block"
      return
    }

    this.resultsTarget.innerHTML = `
      <ul>
        ${results.map(result => `
          <li>
            <a href="${result.url}">
              ${this.escapeHtml(result.title)}
            </a>
            <small>
              ${this.escapeHtml(result.type)} · 
              matched by ${this.escapeHtml(result.matched_by)}
            </small>
          </li>
        `).join("")}
      </ul>
    `
    this.resultsTarget.style.display = "block"
  }

  toggle() {
    const container = this.element.closest(".home-header-search")

    if (!container) return

    const panel = container.querySelector(".compact-search-panel")

    if (!panel) return

    panel.classList.toggle("is-open")

    if (panel.classList.contains("is-open")) {
      const input = panel.querySelector("input")
      if (input) {
        input.focus()
      }
    }
  }

  hideResults(event) {
    // Don't hide if clicking inside results
    if (event && this.resultsTarget.contains(event.relatedTarget)) {
      return
    }
    setTimeout(() => {
      this.resultsTarget.style.display = "none"
    }, 200)
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text ?? ""
    return div.innerHTML
  }
}