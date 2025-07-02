# 🔥 Simulación de Termotanque Eléctrico – ASM para PIC (MPLAB)

Este proyecto es una simulación de un **termotanque eléctrico** implementado en lenguaje ensamblador (ASM) para microcontroladores PIC, utilizando **MPLAB IDE**. A través del uso de **LEDs**, se representan distintos estados del sistema: carga de agua, calentamiento, uso, y reposo.

---

## ⚙️ Descripción general

La lógica del sistema replica el comportamiento típico de un termotanque:

- 🚰 **Carga de agua**: cuando hay menos de 110 L, se activa una bomba (LED amarillo).
- 🔥 **Calentamiento**: si la temperatura está por debajo de 45 °C, se activa una resistencia (LED rojo).
- ✅ **Estado estable**: cuando el agua está llena y caliente, el sistema queda en reposo (LED verde).
- 🚿 **Uso de agua**: se abre una canilla que baja el nivel de agua y enfría la temperatura (LED blanco).

Se utilizan instrucciones básicas del PIC y retardos manuales con bucles para simular el tiempo de los procesos.

---

## 💡 Comportamiento del sistema

| Estado                        | Acción realizada                                | LED |
|------------------------------|--------------------------------------------------|-----|
| Inicio del sistema           | Se activa el sistema                            | Azul (RB1) |
| Agua < 110 L                 | Se prende la bomba y carga agua                 | Amarillo (RB0) |
| Temperatura < 45 °C          | Se activa resistencia y calienta el agua        | Rojo (RB2) |
| Agua ≥ 110 L y Temp ≥ 45 °C  | Sistema en reposo                               | Verde (RB3) |
| Se abre la canilla           | Baja el nivel de agua y temperatura             | Blanco (RB4) |

---

## 🧠 Recursos usados

- 🖥 **Lenguaje**: Ensamblador (ASM)
- 🧰 **IDE**: MPLAB IDE clásico
- 📦 **Microcontrolador**: PIC16F628A
- 💾 **Periféricos simulados**: LEDs en PORTB
- 📐 **Variables en RAM**: `aguaactual`, `aguamax`, `tempactual`, `tempmax`, etc.

---


## 🚀 Cómo compilar y correr

1. Abrí **MPLAB IDE**.
2. Seleccioná el microcontrolador **PIC16F628A**.
3. Creá un nuevo proyecto y agregá el archivo `TERMOTANQUE_BIEN.asm`.
4. Compilá para generar el `.hex`.
5. Usá un simulador como **MPLAB SIM** o cargalo en **Proteus** para ver los LEDs funcionando.

## Autor
Santiago Zurlo
