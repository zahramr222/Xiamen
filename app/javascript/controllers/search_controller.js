import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    this.timeout = null
    console.log("SEARCH CONTROLLER CONNECTED")

    // Handle "/" key to focus search
    document.addEventListener("keydown", (event) => {
      if (
        event.key === "/" &&
        document.activeElement.tagName !== "INPUT"
      ) {
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
      this.resultsTarget.replaceChildren()
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

      const errorMessage = document.createElement("p")
      errorMessage.className = "search-error"
      errorMessage.textContent =
        "Something went wrong. Please try again."

      this.resultsTarget.replaceChildren(errorMessage)
      this.resultsTarget.style.display = "block"
    }
  }

  renderResults(results) {
    this.resultsTarget.replaceChildren()

    if (!results || results.length === 0) {
      const message = document.createElement("p")
      message.className = "search-no-results"

      message.append('No results found for "')

      const strong = document.createElement("strong")
      strong.textContent = this.inputTarget.value

      message.appendChild(strong)
      message.append('"')

      this.resultsTarget.appendChild(message)
      this.resultsTarget.style.display = "block"

      return
    }

    const list = document.createElement("ul")

    results.forEach((result) => {
      const item = document.createElement("li")

      const link = document.createElement("a")

      if (this.isSafeUrl(result.url)) {
        link.href = result.url
      } else {
        link.href = "#"
      }

      link.textContent = result.title ?? ""

      const details = document.createElement("small")
      details.textContent =
        `${result.type ?? ""} · matched by ${result.matched_by ?? ""}`

      item.appendChild(link)
      item.appendChild(details)

      list.appendChild(item)
    })

    this.resultsTarget.appendChild(list)
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
    if (
      event &&
      this.resultsTarget.contains(event.relatedTarget)
    ) {
      return
    }

    setTimeout(() => {
      this.resultsTarget.style.display = "none"
    }, 200)
  }

  isSafeUrl(url) {
    if (!url) return false

    try {
      const parsedUrl = new URL(
        url,
        window.location.origin
      )

      return (
        parsedUrl.protocol === "http:" ||
        parsedUrl.protocol === "https:"
      )
    } catch {
      return false
    }
  }
}