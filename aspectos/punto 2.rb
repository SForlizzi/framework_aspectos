Pry.config.input = STDIN
Pry.config.output = STDOUT

class Aspects

   attr_accessor :listaOrigenes 
   attr_accessor :listaMetodos 
   attr_accessor :listaCondiciones


   def initialize(&condiciones)
         self.listaOrigenes = Array.new
         self.listaMetodos = Array.new
         self.listaCondiciones = Array.new
         self.listaCondiciones << condiciones.to_proc
   end

   def on(*origenes)

      origenes.each do |x|

         if x.nil?
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

   # Lad condiciones devuelven metodos, asi que se pueden tratar como tal
   # Ilustrando:
   # where(name(/foo/, /on/))
   # es where([[met1, met2, me3]. [met4]])
   
   def where(*varios_metodos)
      varios_metodos.flatten
   end

   def name(regex)
      cond = Condicion_selector.new regex, self.listaMetodos
      cond.cumpleCondicion(regex)
   end

   def has_parameters(cant, variant = nil)
      
      if variant.is_a? nil

      elsif variant.is_a? Regexp
         cond = Nombre_parametros.new cant, variant, self.listaMetodos
         cond.cumpleCondicion(regex)
         #  Reconocer si es un enum
         # elsif variant.is_a? Regexp
         #  Condicion_cantidad_parametros
      end

   end

   def neg(*conditions)
      cond = NegateCondition.new *conditions, self.listaMetodos
      cond.cumpleCondicion(regex)
   end

   def transform(*lista_de_metodos)

       # Cuando los orígenes son módulos o clases, todas sus instancias se verán afectadas. Cuando el origen sea una instancia, sólo ésa misma será afectada por las transformaciones.


      cond = NegateCondition.new *conditions, self.listaMetodos
      cond.cumpleCondicion(regex)
   end


end

class Condicion_selector

   attr_accessor :regex_propia 
   attr_accessor :listita_metodos 


   def initialize(regex, metodos)
         self.regex_propia = regex
         self.listita_metodos = metodos
   end

   def self.cumpleCondicion(regex)
      listita_metodos.filter{ |c| c.match(regex) }
   end

end


class Condicion_cantidad_parametros

   attr_accessor :cantidad_propia 
   attr_accessor :enum_propio 
   attr_accessor :listita_metodos 

   def initialize(cantidad, enum)
         self.cantidad_propia = cantidad
         self.enum_propio = enum
         self.listita_metodos = metodos
   end

   def has_parameters(cantidad, enum)
      self.cumpleCondicion(cantidad, enum)
   end

   # El enum puede no pasarse
   def cumpleCondicion(cantidad, enum)

      if enum.nil?
         listita_metodos.filter{|x| x.method.parameters.length == cantidad && x.method.parameters.map{|x, y| x == enum.to_s}}
      elsif enum == "mandatory"
         listita_metodos.filter{|x| x.method.parameters.length == cantidad && x.method.parameters.map{|x, y| x == enum.to_s}}
      elsif enum == "optional"
         listita_metodos.filter{|x| x.method.parameters.length == cantidad && x.method.parameters.map{|x, y| x == enum.to_s}}
      end

   end

end


class Nombre_parametros

   attr_accessor :cantidad_propia 
   attr_accessor :regex_propia 
   attr_accessor :listita_metodos 

   def initialize(n, regex, metodos)
         self.cantidad_propia = n
         self.regex_propia = regex
         self.regex_propia = metodos
   end

   def has_parameters(n, regex)
      self.cumpleCondicion(cantidad, enum)
   end

   def cumpleCondicion(n, regex)
      listita_metodos.filter{|x| x.method.parameters.length == n && x.method.parameters.filter{ |c| c.match(regex)}}
   end

end


class Condicion_negacion

   attr_accessor :condiciones_propias
   attr_accessor :listita_metodos

   def initialize(*condiciones, metodos)
         self.condiciones_propias = condiciones
         self.listita_metodos = metodos
   end

   def neg(*condiciones)
      self.cumpleCondicion(cantidad, enum)
   end

   def cumpleCondicion(*condiciones)
      # self.methods - self.methods.filter{|x| condiciones.each {c -> x.c}}
   end

end

labnd = proc {name(/on/)}


x = Aspects.new(&labnd)
x1 = Aspects.new(&labnd)
x2 = Aspects.new(&labnd)
x3 = Aspects.new(&labnd)
x.on(x1)


binding.pry
