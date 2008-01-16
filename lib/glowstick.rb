require 'rubygems'
require 'opengl'
# require 'mathn'
require 'enumerator'
include Gl, Glu, Glut

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
  end
end

module Glowstick
  VERSION = '1.0.0'
  
  def self.start
    @window = Box.new(0, 500, 0, 20000)
    
    @w = 800
    @h = 400
    
    read
    calculate_domain_and_range
    main
  end
  
  def self.init
    glClearColor(0.0, 0.0, 0.0, 0.0)
    
    glEnable(GL_LINE_SMOOTH)
    glEnable(GL_BLEND)
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    glHint(GL_LINE_SMOOTH_HINT, GL_DONT_CARE)
    
    glShadeModel(GL_FLAT)
  end
  
  def self.read
    @data = File.read(ARGV[0]).split("\n").map { |x| x.to_i }
    puts @data.size
    
    temp = []
    @data.each_with_index do |x, i|
      temp << x if i % 15 == 0
    end
    @data = temp
  end
  
  def self.calculate_domain_and_range
    a = @data.sort
    
    @window.b = a.first
    @window.t = a.last
    @window.l = 0
    @window.r = a.size
    
    @window.inset_percent(10)
  end
    
  def self.plot
    i = 0
        
    @data.each_cons(2) do |a|
      line(i, a[0], i + 1, a[1])
      i += 1
    end
  end
  
  def self.display
    glClear(GL_COLOR_BUFFER_BIT)
    
    plot
    
    print("Hello Stroke", 2, 0, 10)
    
    glutSwapBuffers()
  end
  
  def self.print(text, size, x, y)
    view_size = (@window.r - @window.l).to_f
    window_size = @w.to_f
    xscale = 8 / (window_size / view_size) * (size / 100.0)
    
    GL.Translate(@window.l, @window.b + 100, 0)
    GL.Scale(xscale, 2, 1)
    text.each_byte { |x| glutStrokeCharacter(GLUT_STROKE_ROMAN, x) }
  end
  
  def self.reshape(w = @w, h = @h)
    @w = w
    @h = h
    
    glViewport(0, 0, w, h)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    GLU.Ortho2D(@window.l, @window.r, @window.b, @window.t)
  end
  
  def self.keyboard(key, x, y)
    case (key)
      when ?l
        nil
      when ?r
        glutPostRedisplay()
    end
  end
  
  def self.main
    glutInit
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA)
    glutInitWindowSize(@w, @h) 
    glutInitWindowPosition(100, 100)
    glutCreateWindow("Glowstick")
    init()
    glutDisplayFunc(self.method(:display).to_proc) 
    glutReshapeFunc(self.method(:reshape).to_proc)
    glutKeyboardFunc(self.method(:keyboard).to_proc)
    glutMainLoop()
  end
  
  def self.line(x1, y1, x2, y2)
    glBegin(GL_LINES)
    glVertex((x1),(y1))
    glVertex((x2),(y2))
    glEnd()
  end
end

ARGV[0] = "/Users/tom/memlog2.log"
Glowstick.start