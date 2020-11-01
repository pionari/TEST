package com.kh.livro.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.sound.midi.Soundbank;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.livro.biz.ArtistBiz;
import com.kh.livro.dto.CalendarDto;
import com.kh.livro.dto.SupportCommDto;
import com.kh.livro.dto.SupportDto;

@Controller
public class ArtistController {

	@Autowired
	private ArtistBiz artistBiz;

	private Logger logger = LoggerFactory.getLogger(ArtistController.class);

	@RequestMapping("/artist.do")
	public String artist(Model model, String member_id) {
		model.addAttribute("musicdto", artistBiz.selectList(member_id));
		model.addAttribute("memberdto", artistBiz.selectOne(member_id));
		model.addAttribute("supportdto", artistBiz.supportList(member_id));
		model.addAttribute("profiledto", artistBiz.selectProfile(member_id));
		model.addAttribute("broaddto", artistBiz.broadList(member_id));
		model.addAttribute("caldto", artistBiz.calList(member_id));
		return "artist/artist";
	}

	// 글 입력 (@RestController방식으로 json전달하여 댓글입력)
	// @ResponseEntity : 데이터 + http status code
	// @ResponseBody : 객체를 json으로 (json - String)
	// @RequestBody : json을 객체로
	@RequestMapping(value = "/supportInsert.do", method = RequestMethod.POST)
	public ResponseEntity<String> insertRest(@RequestBody SupportDto dto, HttpSession session) {

		logger.info("[support Insert]");
		ResponseEntity<String> entity = null;

		try {
			artistBiz.supportInsert(dto);
			entity = new ResponseEntity<String>("success", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<String>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		// 입력 처리 HTTP 상태 메시지 리턴
		return entity;
	}

	// 댓글수정
	@RequestMapping(value = "/supportUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public SupportDto updateRest(@RequestBody SupportDto dto) {
		logger.info("수정컨트롤러");
		try {
			artistBiz.supportUpdate(dto);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dto;
	}

	// 글삭제 
	@RequestMapping(value = "/supportDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public int deleteRest(@RequestBody SupportDto dto) {

		logger.info("[support Delete]");
		int res = artistBiz.supportDelete(dto.getSupport_no());
		System.out.println(res);
		
		return res ;
	}

	// 댓글입력 (@RestController방식으로 json전달하여 댓글입력)
	@RequestMapping(value = "/commInsert.do", method = RequestMethod.POST)
	public ResponseEntity<String> commInsert(@RequestBody SupportCommDto dto, HttpSession session) {

		logger.info("[comm Insert]");

		ResponseEntity<String> entity = null;

		try {
			artistBiz.commInsert(dto);
			entity = new ResponseEntity<String>("success", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<String>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		// 입력 처리 HTTP 상태 메시지 리턴
		return entity;
	}
	
	// 응원 댓글 리스트
	@RequestMapping(value = "/showList.do", method = RequestMethod.POST)
	public String replyList(@RequestBody SupportCommDto dto, Model model) {
		logger.info("댓글 출력 컨트롤러");
		model.addAttribute("commdto", artistBiz.commList(dto.getSupport_no()));
		model.addAttribute("memberdto", artistBiz.selectOne(dto.getMember_id()));
		return "artist/artistReply";
	}
	
	// 응원 댓글 삭제
	@RequestMapping(value = "/commDelete.do", method = RequestMethod.POST)
	public ResponseEntity<String> replyDelete(@RequestParam int comm_no) {
		logger.info("댓글삭제 컨트롤러");
		System.out.println(comm_no);
		ResponseEntity<String> entity = null;
		try {
			artistBiz.commDelete(comm_no);
			entity = new ResponseEntity<String>("success", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<String>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		return entity;
	}
	
	// 응원 댓글 업데이트
	@RequestMapping(value="/commUpdate.do", method = RequestMethod.POST)
	public ResponseEntity<String> replyUpdate(@RequestBody SupportCommDto dto) {
		logger.info("댓글 수정 컨트롤러");
		System.out.println(dto.getComm_content());
		System.out.println(dto.getComm_no());
		ResponseEntity<String> entity = null;
		try {
			artistBiz.commUpdate(dto);
			entity = new ResponseEntity<String>("success", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<String>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		return entity;
	}
	

	// 캘린더 insert
	@RequestMapping(value = "/calInsert.do", method = RequestMethod.POST)
	@ResponseBody
	public List<CalendarDto> calInsert(@RequestBody CalendarDto dto) {

		artistBiz.calInsert(dto); // 값 인서트

		List<CalendarDto> list = new ArrayList<CalendarDto>();
		try {
			list = artistBiz.calList(dto.getMember_id());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@RequestMapping(value = "/calUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public void calUpdate(@RequestBody CalendarDto dto) {
		artistBiz.calUpdate(dto);
	}

	@RequestMapping(value = "/calDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public void calDelete(@RequestBody CalendarDto dto) {
		artistBiz.calDelete(dto.getCal_no());
	}

}
