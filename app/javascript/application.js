// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"


        function handleSearch(event) {
            event.preventDefault();
            const input = document.getElementById("searchInput");
            const query = input.value.trim();
            if (!query) {
                input.focus();
                return;
            }
            console.log("Searching for:", query);
            alert("Searching for: " + query);
        }

        document.addEventListener("keydown", function(event) {
            if (event.key === "/" && document.activeElement.tagName !== "INPUT") {
                event.preventDefault();
                document.getElementById("searchInput").focus();
            }
        });

        // D3 World Map
        document.addEventListener("DOMContentLoaded", function() {
            const container = document.getElementById("global-dotted-map");
            if (!container) return;

            function loadScript(src) {
                return new Promise(function(resolve, reject) {
                    const script = document.createElement("script");
                    script.src = src;
                    script.onload = resolve;
                    script.onerror = reject;
                    document.head.appendChild(script);
                });
            }

            async function initializeMap() {
                try {
                    if (typeof d3 === "undefined") {
                        await loadScript("https://cdn.jsdelivr.net/npm/d3@7");
                    }
                    if (typeof topojson === "undefined") {
                        await loadScript("https://cdn.jsdelivr.net/npm/topojson-client@3");
                    }

                    const world = await d3.json("https://cdn.jsdelivr.net/npm/world-atlas@2/countries-110m.json");
                    const width = container.clientWidth;
                    const height = container.clientHeight;

                    const svg = d3.select(container)
                        .append("svg")
                        .attr("viewBox", `0 0 ${width} ${height}`)
                        .attr("preserveAspectRatio", "xMidYMid meet");

                    const defs = svg.append("defs");
                    const pattern = defs.append("pattern")
                        .attr("id", "countryDots")
                        .attr("width", 5)
                        .attr("height", 5)
                        .attr("patternUnits", "userSpaceOnUse");
                    pattern.append("circle")
                        .attr("cx", 1.6)
                        .attr("cy", 1.6)
                        .attr("r", .9)
                        .attr("fill", "#d9dbe2");

                    const projection = d3.geoNaturalEarth1();
                    const path = d3.geoPath().projection(projection);
                    const countries = topojson.feature(world, world.objects.countries);

                    projection.fitExtent([
                        [55, 75],
                        [width - 55, height - 65]
                    ], {
                        type: "FeatureCollection",
                        features: countries.features
                    });

                    svg.append("path")
                        .datum({ type: "Sphere" })
                        .attr("class", "map-sphere")
                        .attr("d", path);

                    svg.append("g")
                        .selectAll("path")
                        .data(countries.features)
                        .join("path")
                        .attr("class", "map-country")
                        .attr("d", path);

                    const offices = [
                        { name: "Tehran", country: "Iran", lat: 35.6892, lng: 51.3890, labelOffset: [-42, -16] },
                        { name: "Bandar Abbas", country: "Iran", lat: 27.1832, lng: 56.2666, labelOffset: [12, 16] },
                        { name: "Dubai", country: "UAE", lat: 25.2048, lng: 55.2708, labelOffset: [12, -15] },
                        { name: "Hong Kong", country: "Hong Kong", lat: 22.3193, lng: 114.1694, labelOffset: [12, -15] }
                    ];

                    const officeLayer = svg.append("g").attr("class", "office-layer");

                    offices.forEach(function(office) {
                        const point = projection([office.lng, office.lat]);
                        if (!point) return;
                        const x = point[0];
                        const y = point[1];
                        const group = officeLayer.append("g").attr("class", "map-office-point");

                        group.append("circle")
                            .attr("class", "map-office-pulse")
                            .attr("cx", x)
                            .attr("cy", y)
                            .attr("r", 8);

                        group.append("circle")
                            .attr("class", "map-office-ring")
                            .attr("cx", x)
                            .attr("cy", y)
                            .attr("r", 5);

                        group.append("circle")
                            .attr("class", "map-office-core")
                            .attr("cx", x)
                            .attr("cy", y)
                            .attr("r", 1.7);

                        const labelX = x + office.labelOffset[0];
                        const labelY = y + office.labelOffset[1];
                        const label = officeLayer.append("g")
                            .attr("class", "map-city-label-group")
                            .attr("transform", `translate(${labelX}, ${labelY})`);

                        const labelWidth = office.name.length * 4.7 + 16;
                        const labelHeight = 17;

                        label.append("rect")
                            .attr("class", "map-city-label-bg")
                            .attr("x", 0)
                            .attr("y", -12)
                            .attr("width", labelWidth)
                            .attr("height", labelHeight);

                        label.append("text")
                            .attr("class", "map-city-label-text")
                            .attr("x", 8)
                            .attr("y", 0)
                            .text(office.name);
                    });

                } catch (error) {
                    console.error("World map could not be loaded.", error);
                }
            }

            initializeMap();

            let resizeTimer;
            window.addEventListener("resize", function() {
                clearTimeout(resizeTimer);
                resizeTimer = setTimeout(function() {
                    container.innerHTML = "";
                    initializeMap();
                }, 250);
            });
        });

