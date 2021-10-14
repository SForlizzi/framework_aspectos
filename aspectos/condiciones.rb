
class Condicion_selector

   attr_accessor :regex_propia 
   attr_accessor :listita_metodos 


   def initialize(regex, metodos)
      self.regex_propia = regex
      self.listita_metodos = metodos
   end

   def self.cumpleCondicion()
      listita_metodos.filter{ |c| c.match(regex_propia) }
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

   # El enum puede no pasarse
   def cumpleCondicion

      if enum_propio.nil?
         # Revisar como se llamaba cuando eran ambos
         # listita_metodos.filter{|x| x.method.parameters.length == cantidad_propia && x.method.parameters.map{|x, y| x == codigo_de_ambos}}
      elsif enum_propio == "mandatory"
         listita_metodos.filter{|x| x.method.parameters.length == cantidad_propia && x.method.parameters.map{|x, y| x == enum_propio.to_s}}
      elsif enum_propio == "optional"
         listita_metodos.filter{|x| x.method.parameters.length == cantidad_propia && x.method.parameters.map{|x, y| x == enum_propio.to_s}}
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

   def cumpleCondicion
      listita_metodos.filter{|x| x.method.parameters.length == cantidad_propia && x.method.parameters.filter{ |c| c.match(regex)}}
   end

end


class Condicion_negacion

   attr_accessor :condiciones_propias
   attr_accessor :listita_metodos

   def initialize(*condiciones, metodos)
         self.condiciones_propias = condiciones
         self.listita_metodos = metodos
   end

   def cumpleCondicion(*condiciones)
      # No voy a plantear esto
   end

end