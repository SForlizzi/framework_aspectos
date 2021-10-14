
class Transformacion_iny

   attr_accessor :pequenio_hash 
   attr_accessor :metodo_a_inyectar 

   def initialize(unHash, unMetodo)
      self.pequenio_hash = unHash
      self.metodo_a_inyectar = unMetodo
   end

   def transformar()

      pequenio_hash.keys.each{
         |llave|

         @parametro = cursorMetodoATransformar.parameters.match(llave)
         @parametros = cursorMetodoATransformar.parameters - @parametro
         @parametros = @parametros + pequenio_hash[llave]
         
         redefinir_metodo = proc {
            # self ?
            metodo_a_inyectar.call(@parametros)
         }

         # ver como cambiar lo del self.
         instance_eval(&redefinir_metodo)

      }

   end

end


# Literalmente toda la logica esta afuera
class Transformacion_red

   attr_accessor :origen 
   attr_accessor :metodo_a_cambiar 

   def initialize(unOrigen, unMetodo)
      self.origen = unOrigen
      self.metodo_a_cambiar = unMetodo
   end

   def transformar()

      # validar si es o no clase
      # este es el Method que paso a string, seria mejor dejarlo como method
      # @metodo_nuevo = origen.method(metodo_a_cambiar)
      origen.method(metodo_a_cambiar.to_s)

   end

end

class Transformacion_log

   attr_accessor :clave_temporal
   attr_accessor :metodo_original 
   attr_accessor :bloque_a_agregar 

   def initialize(unaClave, unMetodo, &bloque)
      self.clave_temporal = unaClave
      self.metodo_original = unMetodo
      self.bloque_a_agregar = bloque
   end

   def transformar()
      # Tambien se podria hacer con un yield

      if clave_temporal == "before"
         redefinir_metodo = proc {
            |params|
            bloque_a_agregar.call
            metodo_original.call(params)
         }
      elsif clave_temporal == "after"
         redefinir_metodo = proc {
            |params|
            metodo_original.call(params)
            bloque_a_agregar.call
         }
      elsif clave_temporal == "instead_of"
         redefinir_metodo = proc {
            bloque_a_agregar.call
         }
      end
      # Esta no devuelve el metodo, sino el proc
      redefinir_metodo
   end

end

