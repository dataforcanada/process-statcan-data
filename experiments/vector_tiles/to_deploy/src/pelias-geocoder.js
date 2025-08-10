/**
 * Pelias Geocoder for MapLibre GL JS
 * Adapted from pelias-mapbox-gl-js for MapLibre compatibility
 */

import maplibregl from 'maplibre-gl';

class PeliasGeocoder {
    constructor(options = {}) {
        this.options = {
            url: options.url || 'https://geocoder.alpha.phac.gc.ca/api/v1',
            apiKey: options.apiKey || '',
            params: options.params || {},
            flyTo: options.flyTo === false ? false : (options.flyTo || {}),
            wof: options.wof === false ? false : true,
            marker: options.marker === false ? false : (options.marker || {}),
            placeholder: options.placeholder || 'Search',
            minLength: options.minLength || 3,
            limit: options.limit || 5,
            customAttribution: options.customAttribution || null
        };

        this.marker = null;
        this.results = [];
        this.selectedIndex = -1;
        this.lastQuery = '';
        this.searchTimeout = null;
    }

    onAdd(map) {
        this.map = map;
        this.container = document.createElement('div');
        this.container.className = 'maplibregl-ctrl pelias-ctrl';

        // Create input
        this.input = document.createElement('input');
        this.input.type = 'text';
        this.input.className = 'pelias-ctrl-input';
        this.input.placeholder = this.options.placeholder;

        // Create clear button
        this.clearBtn = document.createElement('button');
        this.clearBtn.className = 'pelias-ctrl-clear';
        this.clearBtn.innerHTML = '×';
        this.clearBtn.style.display = 'none';

        // Create results container
        this.resultsContainer = document.createElement('div');
        this.resultsContainer.className = 'pelias-ctrl-results';

        // Assemble the control
        this.container.appendChild(this.input);
        this.container.appendChild(this.clearBtn);
        this.container.appendChild(this.resultsContainer);

        // Set up event listeners
        this.setupEventListeners();

        return this.container;
    }

    onRemove() {
        if (this.marker) {
            this.marker.remove();
        }
        this.container.parentNode.removeChild(this.container);
        this.map = undefined;
    }

    setupEventListeners() {
        // Input events
        this.input.addEventListener('input', (e) => {
            const query = e.target.value;
            
            if (query.length >= this.options.minLength) {
                this.clearBtn.style.display = 'block';
                clearTimeout(this.searchTimeout);
                this.searchTimeout = setTimeout(() => {
                    this.search(query);
                }, 300);
            } else {
                this.clearBtn.style.display = 'none';
                this.clearResults();
            }
        });

        // Keyboard navigation
        this.input.addEventListener('keydown', (e) => {
            if (!this.results.length) return;

            switch(e.key) {
                case 'ArrowDown':
                    e.preventDefault();
                    this.selectResult(Math.min(this.selectedIndex + 1, this.results.length - 1));
                    break;
                case 'ArrowUp':
                    e.preventDefault();
                    this.selectResult(Math.max(this.selectedIndex - 1, -1));
                    break;
                case 'Enter':
                    e.preventDefault();
                    if (this.selectedIndex >= 0) {
                        this.chooseResult(this.results[this.selectedIndex]);
                    }
                    break;
                case 'Escape':
                    this.clearResults();
                    this.input.blur();
                    break;
            }
        });

        // Clear button
        this.clearBtn.addEventListener('click', () => {
            this.input.value = '';
            this.clearBtn.style.display = 'none';
            this.clearResults();
            if (this.marker) {
                this.marker.remove();
                this.marker = null;
            }
            this.input.focus();
        });

        // Click outside to close
        document.addEventListener('click', (e) => {
            if (!this.container.contains(e.target)) {
                this.clearResults();
            }
        });
    }

    async search(query) {
        if (query === this.lastQuery) return;
        this.lastQuery = query;

        const params = new URLSearchParams({
            text: query,
            size: this.options.limit,
            ...this.options.params
        });

        if (this.options.apiKey) {
            params.append('api_key', this.options.apiKey);
        }

        // Add focus point if map has a center
        if (this.map) {
            const center = this.map.getCenter();
            params.append('focus.point.lat', center.lat);
            params.append('focus.point.lon', center.lng);
        }

        try {
            const response = await fetch(`${this.options.url}/search?${params}`);
            const data = await response.json();
            
            if (data.features) {
                this.results = data.features;
                this.displayResults();
            }
        } catch (error) {
            console.error('Geocoding error:', error);
            this.showError('Search failed. Please try again.');
        }
    }

    displayResults() {
        this.resultsContainer.innerHTML = '';
        this.selectedIndex = -1;

        if (this.results.length === 0) {
            const noResults = document.createElement('div');
            noResults.className = 'pelias-ctrl-result';
            noResults.textContent = 'No results found';
            this.resultsContainer.appendChild(noResults);
        } else {
            this.results.forEach((result, index) => {
                const item = document.createElement('div');
                item.className = 'pelias-ctrl-result';
                
                const name = document.createElement('div');
                name.className = 'pelias-ctrl-result-name';
                name.textContent = result.properties.name || result.properties.label;
                
                const address = document.createElement('div');
                address.className = 'pelias-ctrl-result-address';
                
                // Build address from properties
                const parts = [];
                if (result.properties.locality) parts.push(result.properties.locality);
                if (result.properties.region) parts.push(result.properties.region);
                if (result.properties.country) parts.push(result.properties.country);
                address.textContent = parts.join(', ');
                
                item.appendChild(name);
                if (address.textContent) {
                    item.appendChild(address);
                }
                
                item.addEventListener('click', () => {
                    this.chooseResult(result);
                });
                
                item.addEventListener('mouseenter', () => {
                    this.selectResult(index);
                });
                
                this.resultsContainer.appendChild(item);
            });
        }
        
        this.resultsContainer.classList.add('active');
    }

    selectResult(index) {
        // Remove previous selection
        const items = this.resultsContainer.querySelectorAll('.pelias-ctrl-result');
        items.forEach((item, i) => {
            if (i === index) {
                item.classList.add('active');
            } else {
                item.classList.remove('active');
            }
        });
        this.selectedIndex = index;
    }

    chooseResult(result) {
        // Update input
        this.input.value = result.properties.label || result.properties.name;
        
        // Clear results
        this.clearResults();
        
        // Get coordinates
        const coords = result.geometry.coordinates;
        
        // Fly to location
        if (this.options.flyTo !== false && this.map) {
            const flyOptions = {
                center: coords,
                zoom: 16,
                ...this.options.flyTo
            };
            this.map.flyTo(flyOptions);
        }
        
        // Add/update marker
        if (this.options.marker !== false && this.map) {
            if (this.marker) {
                this.marker.setLngLat(coords);
            } else {
                const markerOptions = {
                    color: '#FF0000',
                    ...this.options.marker
                };
                this.marker = new maplibregl.Marker(markerOptions)
                    .setLngLat(coords)
                    .addTo(this.map);
            }
        }
        
        // Trigger custom event
        this.container.dispatchEvent(new CustomEvent('select', {
            detail: result
        }));
    }

    clearResults() {
        this.resultsContainer.innerHTML = '';
        this.resultsContainer.classList.remove('active');
        this.results = [];
        this.selectedIndex = -1;
    }

    showError(message) {
        this.resultsContainer.innerHTML = '';
        const error = document.createElement('div');
        error.className = 'pelias-ctrl-error';
        error.textContent = message;
        this.resultsContainer.appendChild(error);
        this.resultsContainer.classList.add('active');
    }

    // Public methods
    setQuery(query) {
        this.input.value = query;
        if (query.length >= this.options.minLength) {
            this.search(query);
        }
    }

    clear() {
        this.input.value = '';
        this.clearBtn.style.display = 'none';
        this.clearResults();
        if (this.marker) {
            this.marker.remove();
            this.marker = null;
        }
    }

    focus() {
        this.input.focus();
    }

    blur() {
        this.input.blur();
    }
}

export default PeliasGeocoder;