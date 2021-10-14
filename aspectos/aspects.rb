Pry.config.input = STDIN
Pry.config.output = STDOUT

require_relative 'condiciones'
require_relative 'transformaciones'

class Aspects

   attr_accessor :listaOrigenes 
   attr_accessor :listaMetodos 
   attr_accessor :listaTransformaciones
   attr_accessor :listaMetodosATransformar
   attr_accessor :cursorMetodoATransformar
   attr_accessor :cursorParametro
   attr_accessor :listaCondiciones


   def initialize(&condiciones)
         self.listaOrigenes = Array.new
         self.listaTransformaciones = Array.new
         self.listaMetodosATransformar = Array.new
         self.listaMetodos = Array.new
         self.listaCondiciones = Array.new
         self.listaCondiciones << condiciones.to_proc
   end

   def on(*origenes)

      origenes.each do |x|

         if x.nil?
            # TODO evitar que pase esto
            puts "vino un null"
         elsif x.is_a? Object
            self.listaOrigenes.push(x)
         elsif x.is_a? Class
            self.listaOrigenes.push(x)
         elsif x.is_a? Module
            self.listaOrigenes.push(x)
         elsif x.is_a? Regexp
            self.listaOrigenes << Object.constants.filter{ |c| c.match(x) }
         end

      end
      
      puts "cantidad de metodos actuales: " + listaMetodos.length.to_s

      self.listaMetodos << self.listaOrigenes.methods
      listaMetodos = where(listaCondiciones)

      puts "cantidad de metodos posterior al where: " + listaMetodos.length.to_s

   end

   # Las condiciones devuelven metodos, asi que se pueden tratar como tal; ilustrando:
   # where(name(/foo/, /on/))
   # es where([[met1, met2, me3]. [met4]])

   def where(*varios_metodos)
      varios_metodos.flatten
   end

   def name(regex)
      cond = Condicion_selector.new regex, self.listaMetodos
      cond.cumpleCondicion
   end

   def has_parameters(cant, variant = nil)
      
      if variant.is_a? nil

      elsif variant.is_a? Regexp
         cond = Nombre_parametros.new cant, variant, self.listaMetodos
         cond.cumpleCondicion
         #  Reconocer si es un enum
         #  elsif variant.is_a? Regexp
         #  Condicion_cantidad_parametros
      end
   end

   def neg(*conditions)
      cond = NegateCondition.new *conditions, self.listaMetodos
      cond.cumpleCondicion
   end

   def transform(*una_lista_de_metodos)

      # TODO Cuando los orígenes son módulos o clases, todas sus instancias se verán afectadas.
      # TODO Cuando el origen sea una instancia, sólo ésa misma será afectada por las transformaciones.
      
      # Insterseccion
      self.listaMetodosATransformar = una_lista_de_metodos & listaMetodos

      listaOrigenes.each{
         |unOrigen| 

         listaMetodosATransformar.each {
            |metodo_a_transformar|

            # Validar el resto y sacar el metodo en base
            if unOrigen.methods.include? metodo_a_transformar

               # Validar el resto y sacar el metodo en base
               if unOrigen.is_a? Class
                  cursorMetodoATransformar = unOrigen.instance_method(metodo_a_transformar)
               else unOrigen.is_a? Object
                  cursorMetodoATransformar = unOrigen.method(metodo_a_transformar)
               end

               listaTransformaciones.each{
                  |trans|
                  unOrigen.instance_eval(trans)
               }

            end
         }
      }
   end

   def inject(unHash)
      tran = Transformacion_iny.new unHash, @cursorMetodoATransformar
      tran.transformar()
   end

   def redirect_to(unOrigen)
      tran = Transformacion_red.new unOrigen, @cursorMetodoATransformar
      tran.transformar()
   end

   def before
      tran = Transformacion_log.new "before", @cursorMetodoATransformar
      tran.transformar()
   end

   def after
      tran = Transformacion_log.new "after", @cursorMetodoATransformar
      tran.transformar()
   end

   def instead_of
      tran = Transformacion_log.new "instead_of", @cursorMetodoATransformar
      tran.transformar()
   end

end

class Interceptor < BasicObject

  def initialize(objeto)
    @objeto = objeto
  end

  def method_missing(symbol, *args, &block)
    @objeto.send(symbol, *args, &block)
  end

end

class Origen

  def initialize()
  
  end

end

class Prueba

  def initialize(objeto)
    @objeto = objeto
  end

  def method_missing(symbol, *args, &block)
    @objeto.send(symbol, *args, &block)
  end

end



binding.pry
