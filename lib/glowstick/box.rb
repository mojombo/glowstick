class Glowstick
  
  class Box
    attr_accessor :l, :r, :b, :t
  
    def initialize(l, r, b, t)
      @l = l
      @r = r
      @b = b
      @t = t
    end
  
    def inset_percent(p)
      @l -= (r - l) * (p / 100.0)
      @r += (r - l) * (p / 100.0)
      @b -= (t - b) * (p / 100.0)
      @t += (t - b) * (p / 100.0)
      self
    end
    
    # Calculate the smallest Box that can contain all of the given boxes
    #   +args+ is the list or Array of Boxes
    #
    # Returns Glowstick::Box
    def self.container(*args)
      boxes = Array(args).flatten
      l = boxes.map { |box| box.l }.min
      r = boxes.map { |box| box.r }.max
      b = boxes.map { |box| box.b }.min
      t = boxes.map { |box| box.t }.max
      Box.new(l, r, b, t)
    end
  end # Box

end # Glowstick