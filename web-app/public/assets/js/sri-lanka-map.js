// Sri Lanka Map Heatmap Configuration
// District paths positioned to resemble Sri Lanka's actual shape

const sriLankaDistricts = {
    // Western Province
    'Colombo': { 
        path: 'M 420 480 L 460 480 L 460 520 L 420 520 Z', 
        x: 440, 
        y: 500 
    },
    'Gampaha': { 
        path: 'M 460 480 L 500 480 L 500 520 L 460 520 Z', 
        x: 480, 
        y: 500 
    },
    'Kalutara': { 
        path: 'M 420 520 L 460 520 L 460 560 L 420 560 Z', 
        x: 440, 
        y: 540 
    },
    
    // Central Province
    'Kandy': { 
        path: 'M 520 520 L 560 520 L 560 560 L 520 560 Z', 
        x: 540, 
        y: 540 
    },
    'Matale': { 
        path: 'M 560 520 L 600 520 L 600 560 L 560 560 Z', 
        x: 580, 
        y: 540 
    },
    'Nuwara Eliya': { 
        path: 'M 520 560 L 560 560 L 560 600 L 520 600 Z', 
        x: 540, 
        y: 580 
    },
    
    // Southern Province
    'Galle': { 
        path: 'M 400 580 L 440 580 L 440 620 L 400 620 Z', 
        x: 420, 
        y: 600 
    },
    'Matara': { 
        path: 'M 400 620 L 440 620 L 440 660 L 400 660 Z', 
        x: 420, 
        y: 640 
    },
    'Hambantota': { 
        path: 'M 400 660 L 440 660 L 440 700 L 400 700 Z', 
        x: 420, 
        y: 680 
    },
    
    // Northern Province
    'Jaffna': { 
        path: 'M 580 300 L 620 300 L 620 340 L 580 340 Z', 
        x: 600, 
        y: 320 
    },
    'Vanni': { 
        path: 'M 620 300 L 660 300 L 660 340 L 620 340 Z', 
        x: 640, 
        y: 320 
    },
    
    // Eastern Province
    'Batticaloa': { 
        path: 'M 700 560 L 740 560 L 740 600 L 700 600 Z', 
        x: 720, 
        y: 580 
    },
    'Digamadulla': { 
        path: 'M 740 560 L 780 560 L 780 600 L 740 600 Z', 
        x: 760, 
        y: 580 
    },
    'Trincomalee': { 
        path: 'M 700 520 L 740 520 L 740 560 L 700 560 Z', 
        x: 720, 
        y: 540 
    },
    
    // North Western Province
    'Kurunegala': { 
        path: 'M 500 500 L 540 500 L 540 540 L 500 540 Z', 
        x: 520, 
        y: 520 
    },
    'Puttalam': { 
        path: 'M 460 480 L 500 480 L 500 520 L 460 520 Z', 
        x: 480, 
        y: 500 
    },
    
    // North Central Province
    'Anuradhapura': { 
        path: 'M 600 440 L 640 440 L 640 480 L 600 480 Z', 
        x: 620, 
        y: 460 
    },
    'Polonnaruwa': { 
        path: 'M 640 480 L 680 480 L 680 520 L 640 520 Z', 
        x: 660, 
        y: 500 
    },
    
    // Uva Province
    'Badulla': { 
        path: 'M 600 600 L 640 600 L 640 640 L 600 640 Z', 
        x: 620, 
        y: 620 
    },
    'Moneragala': { 
        path: 'M 640 640 L 680 640 L 680 680 L 640 680 Z', 
        x: 660, 
        y: 660 
    },
    
    // Sabaragamuwa Province
    'Ratnapura': { 
        path: 'M 500 580 L 540 580 L 540 620 L 500 620 Z', 
        x: 520, 
        y: 600 
    },
    'Kegalle': { 
        path: 'M 540 560 L 580 560 L 580 600 L 540 600 Z', 
        x: 560, 
        y: 580 
    }
};

// Function to get color based on request count
function getColorForCount(count) {
    if (count === 0 || !count) return '#e0e0e0'; // Gray - no requests
    if (count <= 5) return '#fff4e6'; // Light orange
    if (count <= 15) return '#ffcc99'; // Medium orange
    if (count <= 30) return '#ff9966'; // Dark orange
    return '#ff3300'; // Red - very high
}

// Function to initialize the map
function initializeSriLankaMap(requestCounts) {
    const svg = document.querySelector('#sriLankaMap svg');
    if (!svg) return;
    
    // Clear existing content
    svg.innerHTML = '';
    
    // Create Sri Lanka outline (pear-shaped island)
    const sriLankaOutline = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    // Simplified Sri Lanka shape (pear-shaped)
    sriLankaOutline.setAttribute('d', 
        'M 400 280 ' + // Top
        'Q 500 260 600 280 ' + // Top curve
        'L 720 320 ' + // Northeast
        'L 760 400 ' + // East
        'L 740 520 ' + // Southeast
        'L 700 640 ' + // South
        'L 600 720 ' + // Southwest
        'L 480 740 ' + // West
        'L 380 700 ' + // Northwest
        'L 360 600 ' + // North
        'L 380 480 ' + // Center
        'L 400 360 ' + // Upper center
        'Z'
    );
    sriLankaOutline.setAttribute('fill', '#f5f5f5');
    sriLankaOutline.setAttribute('stroke', '#cccccc');
    sriLankaOutline.setAttribute('stroke-width', '2');
    svg.appendChild(sriLankaOutline);
    
    // Add districts
    Object.keys(sriLankaDistricts).forEach(district => {
        const districtData = sriLankaDistricts[district];
        const count = requestCounts[district] || 0;
        const color = getColorForCount(count);
        
        // Create district path
        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute('class', 'district-path');
        path.setAttribute('data-district', district);
        path.setAttribute('d', districtData.path);
        path.setAttribute('fill', color);
        path.setAttribute('stroke', '#ffffff');
        path.setAttribute('stroke-width', '1.5');
        path.setAttribute('data-count', count);
        path.style.cursor = 'pointer';
        path.style.transition = 'all 0.3s ease';
        path.style.opacity = count > 0 ? '0.9' : '0.6';
        
        // Add district label
        const text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        text.setAttribute('x', districtData.x);
        text.setAttribute('y', districtData.y + 5);
        text.setAttribute('text-anchor', 'middle');
        text.setAttribute('font-size', '11');
        text.setAttribute('fill', count > 0 ? '#333' : '#999');
        text.setAttribute('font-weight', count > 15 ? 'bold' : 'normal');
        text.textContent = district;
        text.style.pointerEvents = 'none';
        text.style.userSelect = 'none';
        
        // Hover effects
        path.addEventListener('mouseenter', function(e) {
            const tooltip = document.getElementById('mapTooltip');
            tooltip.innerHTML = `<strong>${district}</strong><br>${count} request${count !== 1 ? 's' : ''}`;
            tooltip.style.display = 'block';
            const rect = svg.getBoundingClientRect();
            const scaleX = svg.viewBox.baseVal.width / rect.width;
            const scaleY = svg.viewBox.baseVal.height / rect.height;
            tooltip.style.left = (e.clientX - rect.left + 15) + 'px';
            tooltip.style.top = (e.clientY - rect.top + 15) + 'px';
            this.setAttribute('stroke-width', '3');
            this.setAttribute('stroke', '#333333');
            this.style.opacity = '1';
        });
        
        path.addEventListener('mousemove', function(e) {
            const tooltip = document.getElementById('mapTooltip');
            const rect = svg.getBoundingClientRect();
            tooltip.style.left = (e.clientX - rect.left + 15) + 'px';
            tooltip.style.top = (e.clientY - rect.top + 15) + 'px';
        });
        
        path.addEventListener('mouseleave', function() {
            document.getElementById('mapTooltip').style.display = 'none';
            this.setAttribute('stroke-width', '1.5');
            this.setAttribute('stroke', '#ffffff');
            this.style.opacity = (this.getAttribute('data-count') > 0) ? '0.9' : '0.6';
        });
        
        svg.appendChild(path);
        svg.appendChild(text);
    });
}
