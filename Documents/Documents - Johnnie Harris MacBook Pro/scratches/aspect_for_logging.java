package org.churchofjesuschrist.mltp.controller;

import java.util.logging.Level;
import java.util.logging.Logger;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;

@Aspect
public class LoggingAspect {

//    @Pointcut("within(org.churchofjesuschrist.mltp.controller..*)")
//    public void controllerMethods() {}

    @Around("execution(* org.churchofjesuschrist.mltp.controller.CdolController.*(..))")
    public Object loggingAdvice(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {
        long start = System.currentTimeMillis();
        Class<?> clazz = proceedingJoinPoint.getTarget().getClass();
        Logger logger = Logger.getLogger(clazz.getName());
        logger.log(Level.INFO, "*** before GET pointcut");
        try {
            Object result = proceedingJoinPoint.proceed();
            long end = System.currentTimeMillis();
            logger.log(Level.INFO, "*** after succesful GET pointcut; execution time: " + (end - start) + " ms.");
            return result;
        } catch (Throwable t) {
            long end = System.currentTimeMillis();
            logger.log(Level.SEVERE, "*** error with GET pointcut: execution time: " + (end - start) + " ms.");
            throw t;
        }
    }

//    private String getRequestUrl(JoinPoint joinPoint, Class clazz) {
//        MethodSignature methodSignature = (MethodSignature) joinPoint.getSignature();
//        Method method = methodSignature.getMethod();
//        GetMapping methodGetMapping = method.getAnnotation(GetMapping.class);
//        RequestMapping requestMapping = (RequestMapping) clazz.getAnnotation(RequestMapping.class);
//        return getGetUrl(requestMapping, methodGetMapping);
//    }
//
//    private String getGetUrl(RequestMapping requestMapping, GetMapping getMapping) {
//        String baseUrl = getUrl(requestMapping.value());
//        String endpoint = getUrl(getMapping.value());
//
//        return baseUrl + endpoint;
//    }
//
//    private String getUrl(String[] urls) {
//        if (urls.length == 0) return "";
//        else return urls[0];
//    }
}
