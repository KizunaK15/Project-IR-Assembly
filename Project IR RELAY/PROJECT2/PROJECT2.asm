.include "m328pdef.inc"   ; Menyertakan definisi untuk ATmega328p

;### Definisi pin untuk perangkat keras
.equ IR_SENSOR_PIN = 0    ; Pin untuk sensor IR (A0 menjadi pin 0)
.equ RED_LED_PIN = PB0    ; Pin untuk LED merah (PB0)
.equ GREEN_LED_PIN = PB1  ; Pin untuk LED hijau (PB1)
.equ RELAY_PIN = PB2      ; Pin untuk relay (PB2)

;### Setup awal, pengaturan pin
    cbi     DDRC, IR_SENSOR_PIN   ; DDRC &= ~(1 << IR_SENSOR_PIN) -> Port C pin 0 input
    sbi     DDRB, RED_LED_PIN     ; DDRB |= (1 << RED_LED_PIN) -> Pin PB0 sebagai output
    sbi     DDRB, GREEN_LED_PIN   ; DDRB |= (1 << GREEN_LED_PIN) -> Pin PB1 sebagai output
    sbi     DDRB, RELAY_PIN       ; DDRB |= (1 << RELAY_PIN) -> Pin PB2 sebagai output

;### Set semua pin output ke LOW, kecuali relay yang harus ON pada awal
    cbi     PORTB, RED_LED_PIN     ; PORTB &= ~(1 << RED_LED_PIN) -> LED merah mati
    cbi     PORTB, GREEN_LED_PIN   ; PORTB &= ~(1 << GREEN_LED_PIN) -> LED hijau mati
    sbi     PORTB, RELAY_PIN       ; PORTB |= (1 << RELAY_PIN) -> Relay menyala (ON)

;### Loop utama program
loop:
    sbis    PINC, IR_SENSOR_PIN    ; Jika (PINC & (1 << IR_SENSOR_PIN)) -> sensor IR HIGH?
    rjmp    no_object              ; Lompat jika tidak ada objek

    ; Jika objek terdeteksi (sensor IR HIGH)
    sbi     PORTB, GREEN_LED_PIN   ; PORTB |= (1 << GREEN_LED_PIN) -> LED hijau menyala
    cbi     PORTB, RED_LED_PIN     ; PORTB &= ~(1 << RED_LED_PIN) -> LED merah mati
    cbi     PORTB, RELAY_PIN       ; PORTB &= ~(1 << RELAY_PIN) -> Relay mati (OFF)
    rjmp    delay

no_object:
    ; Jika tidak ada objek (sensor IR LOW)
    sbi     PORTB, RED_LED_PIN     ; PORTB |= (1 << RED_LED_PIN) -> LED merah menyala
    cbi     PORTB, GREEN_LED_PIN   ; PORTB &= ~(1 << GREEN_LED_PIN) -> LED hijau mati
    sbi     PORTB, RELAY_PIN       ; PORTB |= (1 << RELAY_PIN) -> Relay aktif (ON)

delay:
    ldi     R26, 100   ; Load 100 ke register R26 untuk penundaan
    ldi     R27, 0
    rcall   _delay_ms  ; Panggil fungsi delay_ms
    rjmp    loop       ; Ulangi loop utama

;### Fungsi Delay (100ms)
_delay_ms:
    ldi     R30, 255   ; Load nilai 255 ke R30 untuk loop pertama
    ldi     R31, 255   ; Load nilai 255 ke R31 untuk loop kedua

delay_loop:
    nop                 ; No operation, hanya untuk membuat jeda waktu
    nop
    nop
    nop
    nop
    dec     R30        ; Decrement R30
    brne    delay_loop ; Jika R30 != 0, lanjutkan loop pertama

    dec     R31        ; Decrement R31
    brne    delay_loop ; Jika R31 != 0, lanjutkan loop kedua

    ret                 ; Kembali dari fungsi delay
