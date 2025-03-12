document.addEventListener('DOMContentLoaded', function() {
    // Get the select elements
    const provinceSelect = document.getElementById('province');
    const districtSelect = document.getElementById('district');
    const communeSelect = document.getElementById('commune');
    const villageSelect = document.getElementById('village');
    const form = document.querySelector('form');

    // Initially disable all dependent selects
    districtSelect.disabled = true;
    communeSelect.disabled = true;
    villageSelect.disabled = true;

    // Load provinces on page load
    loadProvinces();

    // Add event listeners
    provinceSelect.addEventListener('change', function() {
        const hasValue = !!this.value;
        districtSelect.disabled = !hasValue;
        communeSelect.disabled = true;
        villageSelect.disabled = true;
        
        if (hasValue) {
            loadDistricts(this.value);
        } else {
            clearSelect(districtSelect);
            clearSelect(communeSelect);
            clearSelect(villageSelect);
        }
    });

    districtSelect.addEventListener('change', function() {
        const hasValue = !!this.value;
        communeSelect.disabled = !hasValue;
        villageSelect.disabled = true;
        
        if (hasValue) {
            loadCommunes(this.value);
        } else {
            clearSelect(communeSelect);
            clearSelect(villageSelect);
        }
    });

    communeSelect.addEventListener('change', function() {
        const hasValue = !!this.value;
        villageSelect.disabled = !hasValue;
        
        if (hasValue) {
            loadVillages(this.value);
        } else {
            clearSelect(villageSelect);
        }
    });

    // Handle form submission if it exists
    if (form) {
        form.addEventListener('submit', function(e) {
            // Only handle if it's the checkout form
            if (form.id === 'checkoutForm') {
                const province = provinceSelect.options[provinceSelect.selectedIndex];
                const district = districtSelect.options[districtSelect.selectedIndex];
                const commune = communeSelect.options[communeSelect.selectedIndex];
                const village = villageSelect.value ? villageSelect.options[villageSelect.selectedIndex] : null;

                // Create hidden inputs to store the location names
                if (!document.getElementById('provinceName')) {
                    const provinceNameInput = document.createElement('input');
                    provinceNameInput.type = 'hidden';
                    provinceNameInput.name = 'provinceName';
                    provinceNameInput.id = 'provinceName';
                    form.appendChild(provinceNameInput);
                }
                if (!document.getElementById('districtName')) {
                    const districtNameInput = document.createElement('input');
                    districtNameInput.type = 'hidden';
                    districtNameInput.name = 'districtName';
                    districtNameInput.id = 'districtName';
                    form.appendChild(districtNameInput);
                }
                if (!document.getElementById('communeName')) {
                    const communeNameInput = document.createElement('input');
                    communeNameInput.type = 'hidden';
                    communeNameInput.name = 'communeName';
                    communeNameInput.id = 'communeName';
                    form.appendChild(communeNameInput);
                }
                if (!document.getElementById('villageName')) {
                    const villageNameInput = document.createElement('input');
                    villageNameInput.type = 'hidden';
                    villageNameInput.name = 'villageName';
                    villageNameInput.id = 'villageName';
                    form.appendChild(villageNameInput);
                }

                // Set the location names
                document.getElementById('provinceName').value = province.text;
                document.getElementById('districtName').value = district.text;
                document.getElementById('communeName').value = commune.text;
                document.getElementById('villageName').value = village ? village.text : '';
            }
        });
    }

    // Functions to load data
    function loadProvinces() {
        fetch('/Ecomere/api/provinces')
            .then(response => response.json())
            .then(data => {
                populateSelect(provinceSelect, data);
            })
            .catch(error => console.error('Error loading provinces:', error));
    }

    function loadDistricts(provinceId) {
        fetch(`/Ecomere/api/districts?provinceId=${provinceId}`)
            .then(response => response.json())
            .then(data => {
                populateSelect(districtSelect, data);
            })
            .catch(error => console.error('Error loading districts:', error));
    }

    function loadCommunes(districtId) {
        fetch(`/Ecomere/api/communes?districtId=${districtId}`)
            .then(response => response.json())
            .then(data => {
                populateSelect(communeSelect, data);
            })
            .catch(error => console.error('Error loading communes:', error));
    }

    function loadVillages(communeId) {
        fetch(`/Ecomere/api/villages?communeId=${communeId}`)
            .then(response => response.json())
            .then(data => {
                populateSelect(villageSelect, data);
            })
            .catch(error => console.error('Error loading villages:', error));
    }

    // Helper functions
    function populateSelect(selectElement, data) {
        // Keep the first option (placeholder)
        const defaultOption = selectElement.options[0];
        selectElement.innerHTML = '';
        selectElement.appendChild(defaultOption);
        
        // Add new options
        data.forEach(item => {
            const option = document.createElement('option');
            option.value = item.id;
            option.textContent = item.name;
            selectElement.appendChild(option);
        });

        // Enable the select
        selectElement.disabled = false;
    }

    function clearSelect(selectElement) {
        // Keep only the first option (placeholder)
        const defaultOption = selectElement.options[0];
        selectElement.innerHTML = '';
        selectElement.appendChild(defaultOption);
        selectElement.disabled = true;
    }
});
