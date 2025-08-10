import maplibregl from 'maplibre-gl';
import * as ss from 'simple-statistics';
import PeliasGeocoder from './pelias-geocoder';

// 2021 Census of Population characteristics
import availableFields from './fields'

let currentField = 'total_1';
let currentClassification = null;
let mapLoaded = false;
let hoveredFeatureId = null;

// Get field from URL parameters
function getFieldFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    const fieldParam = urlParams.get('field');
    if (fieldParam && availableFields.includes(fieldParam)) {
        return fieldParam;
    }
    return 'total_1'; // default
}

// Update URL with current field
function updateURL(field) {
    const url = new URL(window.location);
    url.searchParams.set('field', field);
    window.history.replaceState({}, '', url);
}

// Initialize field from URL
currentField = getFieldFromURL();
document.getElementById('currentField').textContent = `Current field: ${currentField}`;

const map = new maplibregl.Map({
    container: 'map',
    style: "https://tiles.openfreemap.org/styles/liberty",
    zoom: 10,
    center: [-75.695000, 45.424721],
    hash: true,
    maxZoom: 18,
    attributionControl: false,
    dragRotate: false,
    keyboard: false,
    pitchWithRotate: false
});

map.on('style.load', () => {
    map.setProjection({
        type: 'globe',
    });
});

map.on('load', () => {
    mapLoaded = true;
    
    map.addSource('my-vector-tiles', {
        type: 'vector',
        tiles: ['https://tiles.diegoripley.ca/files/census_of_population_vector_tiles_subset_august_12_2025/da_2021_cop/{z}/{x}/{y}.mvt'],
        minzoom: 8,
        maxzoom: 14,
        promoteId: 'da_dguid' // Promote DGUID to feature id for hover state
    });

    // Add controls
    map.addControl(new maplibregl.FullscreenControl(), 'top-left');
    
    // Add Pelias Geocoder
    const geocoder = new PeliasGeocoder({
        params: {
            'boundary.country': 'CAN',
            'boundary.rect.min_lat': 40,
            'boundary.rect.max_lat': 60,
            'boundary.rect.min_lon': -140,
            'boundary.rect.max_lon': -50
        },
        flyTo: {
            duration: 100,
            curve: 1.5
        },
        marker: {
            icon: 'marker',
            color: '#FF0000'
        },
        placeholder: 'Search for places...'
    });
    map.addControl(geocoder, 'top-left');

    // Disable rotation
    map.touchZoomRotate.disableRotation();

    // Add main visualization layer
    map.addLayer({
        'id': 'my-layer',
        'type': 'fill',
        'source': 'my-vector-tiles',
        'source-layer': 'da_2021_cop',
        'paint': {
            'fill-color': '#cccccc',
            'fill-opacity': [
                'case',
                ['boolean', ['feature-state', 'hover'], false],
                0,
                0.7
            ]
        }
    });

    // Add hover outline layer
    map.addLayer({
        'id': 'my-layer-hover',
        'type': 'line',
        'source': 'my-vector-tiles',
        'source-layer': 'da_2021_cop',
        'paint': {
            'line-color': '#ff0000',
            'line-width': [
                'case',
                ['boolean', ['feature-state', 'hover'], false],
                3,
                0
            ],
            'line-dasharray': [2, 2],
            'line-opacity': [
                'case',
                ['boolean', ['feature-state', 'hover'], false],
                1,
                0
            ]
        },
        'layout': {
            'line-cap': 'round',
            'line-join': 'round'
        }
    });

    // Add static outline layer (always visible)
    map.addLayer({
        'id': 'my-layer-outline',
        'type': 'line',
        'source': 'my-vector-tiles',
        'source-layer': 'da_2021_cop',
        'paint': {
            'line-color': '#000',
            'line-width': 0.5,
            'line-opacity': 0.5
        }
    });

    // Use CKMeans by default
    const actualFieldName = `count_${currentField}`;
    addVisualizationLayerWithCKMeans(actualFieldName);

    // Set up hover effects
    setupHoverEffects();
});

function setupHoverEffects() {
    // Mouse move handler for hover state
    map.on('mousemove', 'my-layer', (e) => {
        if (e.features.length > 0) {
            // Remove previous hover state
            if (hoveredFeatureId !== null) {
                map.setFeatureState(
                    { source: 'my-vector-tiles', sourceLayer: 'da_2021_cop', id: hoveredFeatureId },
                    { hover: false }
                );
            }
            
            // Set new hover state
            hoveredFeatureId = e.features[0].properties.da_dguid;
            if (hoveredFeatureId) {
                map.setFeatureState(
                    { source: 'my-vector-tiles', sourceLayer: 'da_2021_cop', id: hoveredFeatureId },
                    { hover: true }
                );
            }
            
            map.getCanvas().style.cursor = 'pointer';
        }
    });

    // Mouse leave handler
    map.on('mouseleave', 'my-layer', () => {
        if (hoveredFeatureId !== null) {
            map.setFeatureState(
                { source: 'my-vector-tiles', sourceLayer: 'da_2021_cop', id: hoveredFeatureId },
                { hover: false }
            );
            hoveredFeatureId = null;
        }
        map.getCanvas().style.cursor = '';
    });
}

// Search functionality
const searchInput = document.getElementById('fieldSearch');
const searchResults = document.getElementById('searchResults');
const currentFieldDiv = document.getElementById('currentField');
const recalculateBtn = document.getElementById('recalculateBtn');
const classificationInfo = document.getElementById('classificationInfo');

searchInput.addEventListener('input', (e) => {
    const query = e.target.value.toLowerCase();

    if (query.length === 0) {
        searchResults.style.display = 'none';
        return;
    }

    const filtered = availableFields.filter(field =>
        field.toLowerCase().includes(query)
    ).slice(0, 5);

    if (filtered.length === 0) {
        searchResults.innerHTML = '<div class="search-item">No fields found</div>';
    } else {
        searchResults.innerHTML = filtered.map(field =>
            `<div class="search-item" data-field="${field}">${field}</div>`
        ).join('');
    }

    searchResults.style.display = 'block';
});

searchResults.addEventListener('click', (e) => {
    if (e.target.classList.contains('search-item')) {
        const selectedField = e.target.getAttribute('data-field');
        if (selectedField && selectedField !== currentField) {
            currentField = selectedField;
            currentFieldDiv.textContent = `Current field: ${currentField}`;
            searchInput.value = '';
            searchResults.style.display = 'none';

            updateURL(currentField);
            addVisualizationLayerWithCKMeans(currentField);
        }
    }
});

document.addEventListener('click', (e) => {
    if (!e.target.closest('.search-container')) {
        searchResults.style.display = 'none';
    }
});

recalculateBtn.addEventListener('click', () => {
    recalculateClassesFromExtent();
});

function calculateCKMeansBreaks(features, field, numClasses = 5) {
    const values = features
        .map(f => f.properties[field])
        .filter(v => v !== null && v !== undefined && !isNaN(v));

    if (values.length === 0) return null;

    const uniqueValues = [...new Set(values)].sort((a, b) => a - b);
    const actualNumClasses = Math.min(numClasses, uniqueValues.length);

    if (actualNumClasses === 1) {
        return {
            breaks: [uniqueValues[0], uniqueValues[0]],
            colors: ['#ff0000'],
            method: 'single-value',
            numClasses: 1
        };
    }

    try {
        const clusters = ss.ckmeans(values, actualNumClasses);
        const breaks = [];
        
        for (let i = 0; i < clusters.length; i++) {
            if (i === 0) {
                breaks.push(Math.min(...clusters[i]));
            }
            breaks.push(Math.max(...clusters[i]));
        }

        const colors = generateColors(actualNumClasses);

        return {
            breaks: breaks,
            colors: colors,
            method: 'ckmeans',
            numClasses: actualNumClasses,
            clusters: clusters.length
        };

    } catch (error) {
        console.warn('CKMeans failed, falling back to quantile classification:', error);
        return calculateQuantileBreaks(values, actualNumClasses);
    }
}

function calculateQuantileBreaks(values, numClasses) {
    const sortedValues = [...values].sort((a, b) => a - b);
    const breaks = [];
    const colors = generateColors(numClasses);

    for (let i = 0; i <= numClasses; i++) {
        const quantile = i / numClasses;
        const index = Math.floor(quantile * (sortedValues.length - 1));
        breaks.push(sortedValues[index]);
    }

    return {
        breaks: breaks,
        colors: colors,
        method: 'quantile-fallback',
        numClasses: numClasses
    };
}

function generateColors(numClasses) {
    const colors = [];
    for (let i = 0; i < numClasses; i++) {
        const intensity = (i + 1) / numClasses;
        const red = Math.round(255);
        const green = Math.round(255 * (1 - intensity));
        const blue = Math.round(255 * (1 - intensity));
        colors.push(`rgb(${red}, ${green}, ${blue})`);
    }
    return colors;
}

function addVisualizationLayerWithCKMeans(field) {
    if (!mapLoaded) return;

    // Update temporary color
    map.setPaintProperty('my-layer', 'fill-color', '#cccccc');
    
    updateClassificationInfo('Loading CKMeans...', 'calculating optimal classes');

    setTimeout(() => {
        recalculateClassesFromExtent();
    }, 500);
}

function recalculateClassesFromExtent() {
    if (!mapLoaded) return;

    const features = map.queryRenderedFeatures({ layers: ['my-layer'] });

    if (features.length > 0) {
        console.log(`Calculating CKMeans classification for ${features.length} features`);
        const actualFieldName = `count_${currentField}`;
        const classification = calculateCKMeansBreaks(features, actualFieldName, 5);

        if (classification) {
            currentClassification = classification;

            const paintExpression = ['case'];

            for (let i = 0; i < classification.breaks.length - 1; i++) {
                const lowerBound = classification.breaks[i];
                const upperBound = classification.breaks[i + 1];

                if (i === 0) {
                    paintExpression.push(['<=', ['get', actualFieldName], upperBound]);
                } else {
                    paintExpression.push([
                        'all',
                        ['>', ['get', actualFieldName], lowerBound],
                        ['<=', ['get', actualFieldName], upperBound]
                    ]);
                }
                paintExpression.push(classification.colors[i]);
            }

            paintExpression.push('#cccccc');

            map.setPaintProperty('my-layer', 'fill-color', paintExpression);
            updateLegend(currentField, classification.breaks, classification.colors);
            updateClassificationInfo(
                `${classification.method} (${classification.numClasses} classes)`,
                `${features.length} features analyzed`
            );

            console.log('Classification applied:', classification);
        }
    } else {
        console.log('No features in current view, trying to get data for initial classification...');
        updateClassificationInfo('CKMeans (5 classes)', 'Pan/zoom to data areas for classification');
    }
}

function updateLegend(field, breaks, colors) {
    const legendContent = document.getElementById('legendContent');
    let legendHTML = '';

    for (let i = 0; i < colors.length && i < breaks.length - 1; i++) {
        const rangeStart = breaks[i];
        const rangeEnd = breaks[i + 1];

        let label;
        if (i === 0) {
            label = `≤ ${rangeEnd.toFixed(0)}`;
        } else {
            label = `${rangeStart.toFixed(0)} - ${rangeEnd.toFixed(0)}`;
        }

        legendHTML += `
            <div class="legend-item">
                <div class="legend-color" style="background-color: ${colors[i]}"></div>
                <span>${label}</span>
            </div>
        `;
    }

    legendContent.innerHTML = legendHTML;
}

function updateClassificationInfo(method, details) {
    classificationInfo.innerHTML = `Classification: ${method}<br><small>${details}</small>`;
}

window.addEventListener('popstate', (e) => {
    const newField = getFieldFromURL();
    if (newField !== currentField && availableFields.includes(newField)) {
        currentField = newField;
        document.getElementById('currentField').textContent = `Current field: ${currentField}`;
        addVisualizationLayerWithCKMeans(currentField);
    }
});

map.on('click', 'my-layer', (e) => {
    if (e.features.length > 0) {
        const feature = e.features[0];
        const properties = feature.properties;
        console.log(`Field: ${currentField}, Value: ${properties[`count_${currentField}`]}`);
        console.log('DGUID:', properties.da_dguid);
        
        const clickLatLong = e.lngLat.wrap();
        const googleMapsURL = `https://www.google.ca/maps/@${clickLatLong.lat},${clickLatLong.lng},17z`;
        const openstreetmapURL = `https://www.openstreetmap.org/#map=17/${clickLatLong.lat}/${clickLatLong.lng}`;
        const bingURL = `https://www.bing.com/maps?FORM=Z9LH2&cp=${clickLatLong.lat}%7E${clickLatLong.lng}&lvl=16.0`;

        new maplibregl.Popup()
            .setLngLat(e.lngLat)
            .setHTML(`
                <div style="font-size: 12px;">
                    <strong>${currentField}:</strong> ${properties[`count_${currentField}`]}<br>
                    <strong>DGUID:</strong> ${properties.da_dguid}<br>
                    <strong>Google Maps:</strong> <a href="${googleMapsURL}" target="_blank">Open</a><br>
                    <strong>OpenStreetMap:</strong> <a href="${openstreetmapURL}" target="_blank">Open</a><br>
                    <strong>Bing:</strong> <a href="${bingURL}" target="_blank">Open</a>
                </div>
            `)
            .addTo(map);
    }
});