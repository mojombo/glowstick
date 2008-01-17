  def print(text, size, x, y)
    view_size = (@window.r - @window.l).to_f
    window_size = @w.to_f
    xscale = 8 / (window_size / view_size) * (size / 100.0)
    
    GL.Translate(@window.l, @window.b + 100, 0)
    GL.Scale(xscale, 2, 1)
    text.each_byte { |x| glutStrokeCharacter(GLUT_STROKE_ROMAN, x) }
  end
  
  def read
    @data = File.read(ARGV[0]).split("\n").map { |x| x.to_i }
    puts @data.size
    
    # temp = []
    # @data.each_with_index do |x, i|
    #   temp << x if i % 15 == 0
    # end
    # @data = temp
  end
