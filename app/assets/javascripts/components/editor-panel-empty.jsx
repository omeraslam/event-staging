var EditorPanelEmpty = React.createClass({
    getInitialState: function() {
        return { items: this.props.items}
    },
    getDefaultProps: function() {
        return { items: [], current_selection: null}
    },

    componentDidMount: function() {
   
    },

    selectItem: function(item) {
        alert('select item: ' + item);
        //this.setState({currentItem: item.id});
        this.props.handleSelectItem(item);
    },

    addNavItem: function() {
        alert(this.props.category);
        switch(this.props.category) {
            case 'coupon':
            var itemObj = {"promo_code": "new coupon item", "discount": "0", "is_fixed": false, "is_active": false};
            break;
            case 'question':
            
            var itemObj = {"question_text": "new question item", "response_required": false, "description": "", "answer_text": "","field_type": null, "ticket_id": null,  "event_id": null, "is_active": false, "free_text_active": false, "free_text": ""};
             
            break;
            case 'ticket':
             var itemObj = {"title": "new ticket item", "description": "1000 of 1000", "price": 0,"is_active": false, "ticket_limit": 1000, "buy_limit": 4, "stop_date": moment().format('YYYY-MM-DD')};
             default:
             break;
        }
        this.state.items.push(itemObj)
        this.setState({items: this.state.items})
        this.selectItem(itemObj);
    },



    render: function() {


   

        return (
            <div className="editor-panel empty">
                <i className="icon icon-ticket"> </i>
                <h1>{this.props.title}</h1>
                <p>{this.props.description}</p>
                <p><button className="btn btn-primary" onClick={this.addNavItem} >{this.props.button_text}</button> </p>
            </div>
        )
   } 
});








 


