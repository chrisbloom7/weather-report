import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "spinner", "svg"]

  connect() {
    this.debouncedFetch = this.debounce(this.fetchLocations, 300);
    this.resultsTarget.classList.add("hidden");
    this.svgTarget.classList.remove("hidden")
    this.spinnerTarget.classList.add("hidden")
  }

  search() {
    const query = this.inputTarget.value.trim();
    if (query.length < 3) {
      this.resultsTarget.innerHTML = "";
      this.resultsTarget.classList.add("hidden");
      return;
    }
    this.debouncedFetch(query);
  }

  fetchLocations(query) {
    fetch(`/locations/autocomplete?query=${query}`)
      .then(response => response.json())
      .then(data => {
        this.resultsTarget.classList.remove("hidden");
        this.resultsTarget.innerHTML = data.map(loc =>
          `<li class="p-2 hover:bg-gray-100 cursor-pointer"
               data-action="click->autocomplete#select"
               data-location="${loc.address}">
            ${loc.address}
          </li>`
        ).join("");
      }).catch(error => console.error("Autocomplete fetch error:", error));
  }

  select(event) {
    this.inputTarget.value = event.target.dataset.location;
    this.resultsTarget.innerHTML = "";
    this.resultsTarget.classList.add("hidden");

    const form = this.inputTarget.closest("form");
    if (form) {
      this.svgTarget.classList.add("hidden")
      this.spinnerTarget.classList.remove("hidden")
      form.requestSubmit();
    }
}

  debounce(func, wait) {
    let timeout;
    return (...args) => {
      clearTimeout(timeout);
      timeout = setTimeout(() => func.apply(this, args), wait);
    };
  }
}
