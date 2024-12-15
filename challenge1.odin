package challenge_1

import "core:fmt"
import net "core:net"
import "core:bytes"
import "core:log"
import "core:os"

connect_player :: proc(listen_socket :net.TCP_Socket,  client_connected: ^bool) {
	j := 0
 client_socket, _, accept_error := net.accept_tcp(listen_socket)

        if accept_error != nil {
            log.errorf("failed to accept connection:", accept_error)
        }

client_connected^ = true

if client_connected^ {
	j += 1
}

	buf : [2048]u8
b: bytes.Buffer
    bytes.buffer_init_allocator(&b, 0, 2048)
    io := bytes.buffer_to_stream(&b)
    
	fmt.wprint(io, "connection", j , " ", true)
    	welcome_message := bytes.buffer_to_bytes(&b)
	
	m, err := os.read(os.stdin, buf[:])

	if err != nil {
		fmt.eprintln("Error reading: ", err)
		return
	}

   



        i := 0
        for i < len(welcome_message) {
            n, send_error := net.send_tcp(client_socket, welcome_message)
            if send_error != nil {
                log.errorf("failed to send data:", send_error )
                break
            }
            i += n
        }


        k := 0
	for k < len(buf) {

            z, send_error2 := net.send_tcp(client_socket, buf[:m] )
	if send_error2 != nil {
                log.errorf("failed to send data:", send_error2 )
                break
            }

            k += z

	}

        net.close(client_socket) 
    }


   // TODO write_in_tui :: proc () {} 


main :: proc() {
	
	    endpoint, endpoint_parse_ok := net.parse_endpoint("127.0.0.1:30")
    client_connected :bool = false

    if !endpoint_parse_ok {
        fmt.println("failed to parse endpoint")
        return
    }

    listen_socket, err_2 := net.listen_tcp(endpoint)
    defer net.close(listen_socket)

    if err_2 != nil {
        fmt.println(err_2, "error starting server")
        return
    }



    fmt.println("Server is listening on port:", endpoint)



    	
    for  {

	   if !client_connected { 
	    connect_player(listen_socket,  &client_connected)
	   }

       }


       }
