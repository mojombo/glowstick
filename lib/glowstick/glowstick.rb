class Glowstick
  
  ###########################################################################
  # Class
  
  class << self
    attr_accessor :graphs
  end
  
  self.graphs = []
  
  def self.register(graph)
    self.graphs << graph
  end
  
  ###########################################################################
  # Instance
  
  def initialize(handler)
    @window = Box.new(0, 1, 0, 1)
    @handler = handler
    @w = 800
    @h = 400
  end
  
  def display
    # clear the buffer
    glClear(GL_COLOR_BUFFER_BIT)
    
    # # calculate and apply the current view size
    boxes = Glowstick.graphs.map { |g| g.bounding_box }
    if boxes.empty?
      @window = Box.new(0, 1, 0, 1)
    else
      @window = Box.container(boxes).inset_percent(10)
    end
    
    reshape
    
    # draw each graph
    Glowstick.graphs.each do |graph|
      graph.draw
    end
    
    # swap buffer
    glutSwapBuffers()
  end
  
  def reshape(w = @w, h = @h)
    @w = w
    @h = h
    
    glViewport(0, 0, w, h)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    GLU.Ortho2D(@window.l, @window.r, @window.b, @window.t)
  end
  
  def keyboard(key, x, y)
    case (key)
      when ?r
        glutPostRedisplay()
    end
  end
  
  def idle
    return unless @handler.respond_to?(:idle)
    
    should_draw = @handler.idle
    if should_draw
      glutPostRedisplay
    end
  end
  
  def start
    glutInit
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA)
    glutInitWindowSize(@w, @h) 
    glutInitWindowPosition(100, 100)
    glutCreateWindow("Glowstick")
    
    glClearColor(0.0, 0.0, 0.0, 0.0)
    glEnable(GL_LINE_SMOOTH)
    glEnable(GL_BLEND)
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
    glHint(GL_LINE_SMOOTH_HINT, GL_DONT_CARE)
    glShadeModel(GL_FLAT)
    
    glutDisplayFunc(self.method(:display).to_proc) 
    glutReshapeFunc(self.method(:reshape).to_proc)
    glutKeyboardFunc(self.method(:keyboard).to_proc)
    glutIdleFunc(self.method(:idle).to_proc)
    
    glutMainLoop()
  end
end