# Comparación entre Registros F y W utilizando el bit Z del Registro STATUS

Esta explicación detalla cómo los microcontroladores PIC utilizan el **bit Z** del registro **STATUS** para realizar comparaciones indirectas entre dos registros, sin necesidad de una instrucción explícita de "comparar".

---

## Contexto
En los microcontroladores PIC, las operaciones aritméticas y lógicas afectan directamente el estado de varios bits en el registro **STATUS**. Uno de estos bits es el **bit Z** (bit 2), que indica si el resultado de una operación es igual a cero.

Esto es especialmente útil para comparar el contenido de dos registros o el valor de un registro con una constante. La comparación se realiza indirectamente a través de una operación de resta.

---

## Bit Z en el Registro STATUS
El bit Z se comporta de la siguiente manera:
- **Z = 1**: El resultado de la operación es igual a **0**.
- **Z = 0**: El resultado de la operación es distinto de **0**.

---

## Ejemplo de Código
A continuación se muestra un fragmento de código que utiliza el **bit Z** para comparar un registro llamado `CONTA` con el valor `10`:

```assembly
    incf    CONTA, F          ; Incrementamos el registro CONTA
    movlw   .10               ; Cargamos el valor de 10 en el registro W
    subwf   CONTA, W          ; Restamos W - CONTA, afectando el bit Z
    btfss   STATUS, 2         ; Verificamos si el bit Z está en 1 (resultado = 0)
    goto    $-9               ; Si Z = 0, regresamos 9 instrucciones (repetimos el ciclo)
    goto    inicio            ; Si Z = 1, reiniciamos el ciclo desde inicio
```

---

## Desglose Línea por Línea
### 1. `incf CONTA, F`
- Incrementa el valor del registro `CONTA` en 1.
- El sufijo `F` indica que el resultado se almacena en el propio registro `CONTA`.

### 2. `movlw .10`
- Carga el valor constante `10` en el registro de trabajo `W`. Este valor se utilizará para comparar con el registro `CONTA`.

### 3. `subwf CONTA, W`
- Resta el valor del registro `CONTA` del registro `W`:
  - **(W - CONTA)**.
- Esta operación no modifica el contenido de `CONTA` ni de `W` directamente, pero actualiza los bits del registro **STATUS**, incluyendo el bit Z:
  - Si el resultado de la resta es **0** (W = CONTA), el bit Z se pone en **1**.
  - Si el resultado es diferente de 0, el bit Z queda en **0**.

### 4. `btfss STATUS, 2`
- Evalúa el estado del bit Z (bit 2 del registro STATUS):
  - Si **Z = 1** (los valores eran iguales), se **salta la siguiente instrucción**.
  - Si **Z = 0** (los valores eran diferentes), ejecuta la instrucción siguiente.

### 5. `goto $-9`
- Si los valores eran diferentes, regresamos 9 instrucciones hacia arriba, volviendo al inicio del ciclo donde se lee el registro `CONTA` y se actualiza el valor de salida.

### 6. `goto inicio`
- Si los valores eran iguales (Z = 1), el ciclo ha terminado, y el programa regresa a la etiqueta `inicio` para reiniciar el proceso.

---

## Resumen del Flujo
1. **Incrementamos** el valor del registro `CONTA`.
2. **Cargamos** el valor `10` en el registro de trabajo `W`.
3. **Comparamos** `CONTA` con `10` a través de una resta indirecta que afecta el bit Z.
4. Si los valores son diferentes (**Z = 0**), repetimos el ciclo.
5. Si los valores son iguales (**Z = 1**), reiniciamos el programa desde el inicio.

---

## Conclusión
El uso del **bit Z** del registro STATUS permite implementar comparaciones de manera eficiente, aprovechando las operaciones aritméticas ya disponibles en el microcontrolador PIC. Este enfoque es común en aplicaciones embebidas donde se busca maximizar el uso de los recursos disponibles.


