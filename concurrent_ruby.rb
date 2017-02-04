require 'concurrent'
require 'benchmark'

SYMBOLS = ['MA', 'PCLN', 'ADP', 'V', 'TSS', 'FISV', 'EBAY', 'PAYX', 'WDC', 'SYMC',
           'AAPL', 'AMZN', 'KLAC', 'FNFV', 'XLNX', 'MSI', 'ADI', 'VRSN', 'CA', 'YHOO']

def modify_symbols(symbol)
  symbol += " is a symbol."
end

def serial_modify_sybmols
  SYMBOLS.collect do |symbol|
    modify_symbols(symbol)
  end
end

def concurrent_modify_symbols
  symbols = SYMBOLS.collect do |symbol|
    Concurrent::Future.execute { modify_symbols(symbol) }
  end
  symbols.collect { |symbol| symbol.value }
end

puts 'Warm up...'
p concurrent_modify_symbols
puts "\n"

Benchmark.bmbm do |bm|
  bm.report('serial') do
    serial_modify_sybmols
  end

  bm.report('concurrent') do
    concurrent_modify_symbols
  end
end

__END__

Warm up...
["MA is a symbol.", "PCLN is a symbol.", "ADP is a symbol.", "V is a symbol.", "TSS is a symbol.", "FISV is a symbol.", "EBAY is a symbol.", "PAYX is a symbol.", "WDC is a symbol.", "SYMC is a symbol.", "AAPL is a symbol.", "AMZN is a symbol.", "KLAC is a symbol.", "FNFV is a symbol.", "XLNX is a symbol.", "MSI is a symbol.", "ADI is a symbol.", "VRSN is a symbol.", "CA is a symbol.", "YHOO is a symbol."]

Rehearsal ----------------------------------------------
serial       0.000000   0.000000   0.000000 (  0.000011)
concurrent   0.000000   0.000000   0.000000 (  0.001751)
------------------------------------- total: 0.000000sec

                 user     system      total        real
serial       0.000000   0.000000   0.000000 (  0.000021)
concurrent   0.000000   0.000000   0.000000 (  0.001476)