var EditorDesign = React.createClass({
    getInitialState: function() {
        return {eventObj: this.props.eventObj}
    },

    componentWillReceiveProps: function(nextProps) {
        this.setState({eventObj: nextProps.eventObj})
    },

    onDesignUpdate: function(callBack) {
      var method, uri;
      
      method = 'PUT'
      uri = '/events/' + this.props.eventObj.id
      $.ajax({
        method: method,
        url: uri,
        data: {"event": this.props.eventObj},
        dataType: 'JSON',
        success: function() {
 
        }.bind(this)
      });
    },

    onClosePanel: function() {
      $(".design-editor-section-container").removeClass("visible");
    },
    onUploadBtnClick: function() {
       $('.file-label').click();
    },
    componentDidMount: function() {

      var that = this;

        $('.toggleDesignPanel').click(function() {
            $(".design-editor-section-container").addClass("visible");
            $(".toggleEditorPanel.active").removeClass("active");
            $(".event-editor-section-container").removeClass("visible");

        });

       

        var imageModal = $('#image-search-modal').remodal();

        $('.open-image-modal').click(function(e){
          e.preventDefault();
          imageModal.open();
      });


          var currentBgOpacity = $('#bg_opacity').val()? $('#bg_opacity').val(): ".5"; 
          var currentBgColor = $('#bg_color').val()? $('#bg_color').val(): "#222"; 

            $( "#slider" ).slider({
            value: (currentBgOpacity != undefined) ? currentBgOpacity*100 : 0,
            slide: function( event, ui ) { 

              var percentage = ui.value/100;
              $(".event-page .overlay").css("opacity", percentage);
              that.props.eventObj.bg_opacity = percentage;
              that.setState({eventObj: that.props.eventObj})
              that.onDesignUpdate();
            }
          });

          //background color picker
        $('input#color').minicolors({ 
          position: 'top left', 
          defaultValue: currentBgColor,
          change: function(value, opacity) {
              $(".event-page .overlay").css("background-color", value);
              that.props.eventObj.bg_color = value;
              that.setState({eventObj: that.props.eventObj})
              that.onDesignUpdate();

          }
       });


        //DESIGN > LAYOUT 
        //contruct the layout selector based on html visibility
        $(".test-show-layout").each(function() {

            var target = $(this).data("target");
            if ($(target).hasClass("hidden")) {       
              $(this).addClass("inactive");

            } 
        });




      
        //DESIGN > LAYOUT 
        //click handler for layout select
        var that = this;
        $(".test-show-layout").on( "click", function() {
          
          var target = $(this).data("target");
          
          if ($(target).hasClass("hidden")) { 
            
            $(target).removeClass("hidden");
            $(this).removeClass("inactive");
            $('html, body').animate({
              scrollTop: $(target).offset().top - 50
            }, 200);



          } else {
            
            $(target).addClass("hidden");
            $(this).addClass("inactive");

           

          }

          htmlHeroOne = $("#htmlHeroOne").froalaEditor('html.get');
          htmlBodyOne = $("#htmlBodyOne").froalaEditor('html.get');
          htmlFooterOne = $("#htmlFooterOne").froalaEditor('html.get');

          that.props.eventObj.html_hero_1 = htmlHeroOne;
          that.props.eventObj.html_body_1 = htmlBodyOne;
          that.props.eventObj.html_footer_1 = htmlFooterOne;

          that.setState({eventObj: that.props.eventObj});

          that.onDesignUpdate();
        
        });


    },
    render: function() {
        var imgUrl = (this.state.eventObj.background_img == undefined || this.state.eventObj.background_img.url == null)  ? '/assets/themes/default_bg.jpg' : this.state.eventObj.background_img.url;
        if(this.state.eventObj.external_image != '' &&  this.state.eventObj.external_image != null) {
       
            imgUrl = this.state.eventObj.external_image;
        }

        var divStyle = {
            backgroundImage: 'url(' + imgUrl + ')'
        }


        return (

            <div className="design-editor-section-container">
                <div className="design-editor-header text-right">
                    <a id="design-panel-close" onClick={this.onClosePanel} ><i className="icon icon-arrow-left"> </i></a>
                </div>

                <div className="design-editor-body">
                    <section>
                        <h4>Layout </h4>
                        <p>Show or hide sections of your event website. </p>
                        <div className=" layout-select">
                            <ul> 
                                <li className="test-show-layout"  data-target="#about">About <i className="fa fa-eye"> </i></li>
                                <li className="test-show-layout" data-target="#speakers">Speakers <i className="fa fa-eye"> </i></li>
                                <li className="test-show-layout" data-target="#program">Program/Schedule <i className="fa fa-eye"> </i></li>
                                <li className="test-show-layout" data-target="#sponsors">Sponsors <i className="fa fa-eye"> </i></li>
                            </ul>
                        </div>
                    </section>
                    <section>
                        <h4>Background image/color </h4>
                        <p>Modify your website's main background here. </p>
                        <div className="editor-current-bg upload-btn" onClick={this.onUploadBtnClick} style={divStyle} > </div>  
                        <a className="upload-btn btn btn-small" onClick={this.onUploadBtnClick}> <i className="fa fa-upload"> </i> Upload image </a> 
                        <a className="open-image-modal btn btn-small"> <i className="fa fa-search"> </i> Search image library </a> 
                    </section>  
                    <section>
                        <div className="slider-container">
                            <div className="slider"> <div id="slider"></div> </div>
                            <div className="color-picker"><input id="color" /></div>
                        </div>
                    </section>  

                </div>
            </div>
        )
    }
})