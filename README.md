# philippines-psgc

A list of regions, provinces, cities/municipalities according to the latest PSGC (Philippine Standard Geographic Code) publications published by xpanse.

Disclaimer: This is a growing repository of our understanding of the Philippine Address system and we might have mistakes with the way we classify, collect, and present data so please use the data accordingly. We also don't claim rights to owning PSGC's data. We're merely transforming the Excel publications they put out every month and transform them.

# Notes

### Philippine Address Classifications

1. Regions
2. Provinces
3. Districts<sup>1</sup>
4. Cities
5. Municipalities
6. Sub-Municipalities<sup>2</sup>
7. Barangays
8. Purok<sup>3</sup>

<sup>1</sup>Metro Manila is the only province that uses districts  
<sup>2</sup>The city of Manila (Metro Manila) is the only city that uses sub-municipalities  
<sup>3</sup>Purok is less common in Metro Manila but is sometimes used as the Address 1 or Address 2 entries  

### PSGC code breakdown:

The PSGC uses a code for each of the entries and it follows the following format:

```
RRPPMMBBB
–––––––––
RR for Region
PP for Province
MM for City/Municipalities
BBB for Barangays
```

### Metro Manila (Province)

Metro Manila is the only province that uses districts and has four of them with the following list of cities: 
- First District: Manila
- Second District: Mandaluyong, Marikina, Pasig, San Juan, and Quezon City
- Third District: Caloocan, Malabon, Navotas, and Valenzuela City
- Fourth District: Las Piñas, Makati, Muntinlupa, Parañaque, Pasay, Pateros, and Taguig City

#### Manila (City)

omgwtfbbq

I don't know who decided to zone Manila but it's such a PITA. 

# TODO

- [x] Fix Incorrect Provinces: MM Districts, City of Isabela, and Cotabato City
- [ ] Add Barangays
- [x] Export to JSON
- [ ] Export to CSV
- [ ] Edit readme with instructions on how to run `app.rb`
- [ ] Finish notes
- [ ] Fix PSGC codes