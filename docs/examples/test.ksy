meta:
  id: test
  file-extension: test
  endian: le
  
seq:
  - id: lengths
    type: full_mid_peak_lens
  
  - id: full_data
    size: lengths.full_len
    
  - id: mid_data
    size: lengths.mid_len
    
  - id: peak_data
    size: lengths.peak_len
  
types:
  full_mid_peak_lens:
    seq:
      - id: full_len
        type: u4
      - id: mid_len
        type: u4
      - id: peak_len
        type: u4