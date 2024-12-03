package challenge_1


import "core:fmt"
import n "core:net"
import "core:bytes"
import "core:log"




main :: proc() {

	endpoint , endpoint_parse_ok := n.parse_endpoint("127.0.0.1:30")

	if ! endpoint_parse_ok {
			fmt.println("failed to parse endpoint")
			return
	}

	listen_socket, err_2 := n.listen_tcp(endpoint)
	defer n.close(listen_socket)

	if err_2 != nil {
			fmt.println(err_2, "error  starting server")
		return
	}

	fmt.println("Server is listening on port:",endpoint) 


	b: bytes.Buffer
	bytes.buffer_init_allocator(&b,0,2048)
	bytes.buffer_write_string(&b, "HTTP/1.1 200 OK\r\n")


	welcome_message := bytes.buffer_to_bytes(&b)

	for {

		client_socket, _, accept_error := n.accept_tcp(listen_socket)

		if accept_error != nil {

			log.errorf("failed to accept connection:", accept_error)

			continue
		}


		i := 0
		for i < len(welcome_message) {
			n, send_error := n.send_tcp(client_socket,welcome_message)
			if send_error != nil {
			log.errorf("failed to accept connection:", send_error) 

				break

			}
			i += n

		}

	}


	


}
