class Glowstick
  
  class Graph
    attr_accessor :data, :color
    
    def initialize
      @data = []
      @color = [1, 1, 1]
      @box = Box.new(0, 1, 0, 1)
      Glowstick.register(self)
    end
    
    def add(val)
      @data << val
    end
    
    def bounding_box
      @box.b = @data.min || 0
      @box.t = @data.max || 1
      @box.l = 0
      @box.r = @data.size
      
      @box.t = @box.b + 1 if @box.b == @box.t
      @box.r = 1 if @box.r == 0
      
      @box
    end
    
    def draw
      glColor3f(*@color)
      
      i = 0
        
      @data.each_cons(2) do |a|
        line(i, a[0], i + 1, a[1])
        i += 1
      end
    end
    
    def line(x1, y1, x2, y2)
      glBegin(GL_LINES)
      glVertex((x1),(y1))
      glVertex((x2),(y2))
      glEnd()
    end
  end # Graph
  
end # Glowstick