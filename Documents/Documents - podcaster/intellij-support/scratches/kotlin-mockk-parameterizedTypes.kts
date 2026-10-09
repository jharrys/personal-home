
import com.fasterxml.jackson.databind.JsonNode
import io.mockk.every
import io.mockk.junit5.MockKExtension
import io.mockk.mockk
import io.mockk.mockkConstructor
import io.mockk.spyk
import io.mockk.verify
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.junit.jupiter.api.extension.Extensions
import org.lds.mlp.platform.common.response.DataResponse
import org.springframework.core.ParameterizedTypeReference
import org.springframework.http.HttpEntity
import org.springframework.http.HttpMethod
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.oauth2.client.OAuth2RestTemplate
import kotlin.reflect.KClass

/**
 * shows mockkConstructor
 * shows easy creation of inline reified extension for all parameterized types
 * in Java you needed to do "ParameterizedTypeReference<List<String>>() {}" everywhere you needed it!
 * in Kotlin, you just need to define this once: "inline fun <reified T: Any> typeRef(): ParameterizedTypeReference<T> = object: ParameterizedTypeReference<T>(){}"
 *
 * NOTE: kClassTypeRef<T>() and typeRef<T>() may show warning "Remove explicit type arguments" (or be greyed out in IDEs).
 * This is because the method you are referring to is not overridden or overloaded, hence there is only one method mockk can call.
 * If you were overriding or overloading the method, you would see this warning go away or the type no longer be greyed out.
 *
 * dependencies:
 * 1. spring-boot-start-test (has junit-jupiter 5.6.3)
 * 2. io.mockk:mockk:1.12.0
 */

@Extensions(
    ExtendWith(MockKExtension::class)
)
internal class SomeTest {

    private val headers: MutableMap<String, String?> = mutableMapOf()

    @BeforeEach
    fun setup() {
        headers.putAll(
            mapOf(
                "site" to "music",
                "subType" to null,
                "lang" to "eng",
                "contentType" to "application/json",
                "status" to "PUBLISHED",
                "messageType" to "song"
            )
        )
    }

    class Dummy(val firstBool: Boolean) {
        fun isEqualTo(secondBool: Boolean): Boolean {
            return firstBool == secondBool
        }

        fun isEqualTo(secondParam: String): Boolean {
            return true
        }
    }

    @Test
    fun `showing off kClassTypeRef`() {
        mockkConstructor(Dummy::class)
        every {
            constructedWith<Dummy>().isEqualTo(
                secondBool = any()
            )
        } returns true

        val falseDummy = spyk(Dummy(false))
        falseDummy.isEqualTo(true)

        // this verifies succeeds since we used a boolean
        verify(exactly =  1) {
            falseDummy.isEqualTo(ofType(kClassTypeRef<Boolean>()))
        }

        // this verifies fails as we are using a typeRef of String
        verify(exactly =  1) {
            falseDummy.isEqualTo(ofType(kClassTypeRef<String>()))
        }

    }

    @Test
    fun `showing off typeRef`() {
        val oAuth2RestTemplate = mockk<OAuth2RestTemplate>()
        every {
            oAuth2RestTemplate.exchange(
                ofType<String>(),
                HttpMethod.GET,
                ofType<HttpEntity<*>>(),
                typeRef<DataResponse<List<JsonNode>>>(),
                *anyVararg()
            )
        } returns ResponseEntity(DataResponse(listOf()), HttpStatus.OK)

        // do some verify function here.
    }

    inline fun <reified T: Any> kClassTypeRef(): KClass<T> = T::class

    inline fun <reified T: Any> typeRef(): ParameterizedTypeReference<T> = object: ParameterizedTypeReference<T>(){}
}